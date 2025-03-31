# frozen_string_literal: true

require 'active_support/core_ext/hash/keys'
module AllinsonFlex
  # @todo move custom error classes to a single location
  class NoAllinsonFlexContextError < StandardError; end
  class NoAllinsonFlexSchemaError < StandardError; end

  class DynamicSchemaService
    attr_accessor :dynamic_schema, :context, :context_id, :model

    class << self
      # Retrieve the properties for the model / work type
      # This is a class method called by the model at class load
      #   meaning AdminSet is not available and we cannot get the
      #   contextual dynamic_schema
      # Instead we use the default (contextless) dynamic_schema
      #   which will add all properties available for that class
      # @return [Array] property#to_sym
      def default_properties(work_class_name:)
        props = schema(
          work_class_name: work_class_name
        )['properties'].symbolize_keys!.keys
        props << :dynamic_schema_id
        props
      rescue StandardError => e
        []
      end

      # Retrieve the latest default dynamic_schema
      def schema(work_class_name:, context: nil)
        context ||= AllinsonFlex::Context.where(name: 'default')
        AllinsonFlex::DynamicSchema.where(
          allinson_flex_class: work_class_name,
          context: context
        ).order('created_at').last.schema
      rescue StandardError
        {}
      end

      # Retrieve the predicate for the given predicate uri
      # @param predicate_uri
      # @return [RDF::URI] predicate
      def predicate_for(predicate_uri:)
        ::RDF::URI.intern(predicate_uri)
      end

      # @return [RDF::URI] rdf_type
      def rdf_type(work_class_name:)
        rdf_type_for(
          type: schema(work_class_name: work_class_name)['type'],
          work_class_name: work_class_name
        )
      end

      # @param type - the rdf type value
      # @param model - the work type
      # @return [RDF::URI] rdf_type for given model
      def rdf_type_for(type:, work_class_name:)
        if type.blank?
          ::RDF::URI.intern("http://example.com/#{work_class_name}")
        else
          ::RDF::URI.intern(type)
        end
      end

      def dynamic_schema_property
        {
          predicate: predicate_for(predicate_uri: 'http://example.com/dynamic_schema'),
          multiple: false
        }
      end
    end

    def initialize(admin_set_id:, work_class_name:, dynamic_schema_id: nil)
      context_for(admin_set_id: (admin_set_id || AdminSet::DEFAULT_ID))
      dynamic_schema_for(
        context_id: context_id,
        work_class_name: work_class_name,
        dynamic_schema_id: dynamic_schema_id
      )
      @model = work_class_name
    end

    # @return [Hash] property => array of indexing
    def indexing_properties
      indexers = {}
      properties.each_pair do |prop_name, prop_value|
        indexers[prop_name] = if prop_value[:indexing].blank?
                                ["#{prop_name}#{default_indexing}"]
                              else
                                prop_value[:indexing].map do |indexing_key|
                                  "#{prop_name}#{index_as(indexing_key)}" if index_as(indexing_key)
                                end.compact.uniq
        end
      end
      indexers[:profile_version] = ['profile_version_ssi']
      indexers[:dynamic_schema_id] = ['dynamic_schema_id_ssi']
      indexers
    end

    # @return [Array] property keys
    def property_keys
      @property_keys ||= properties.keys
    end

    # @return [Array] required properties
    def required_properties
      property_keys.map { |prop| required_for(prop) }.compact
    end

    # @todo renderers and other controls
    # @return [Array] hashes of property => label
    def view_properties
      property_keys.map do |prop|
        { prop => { label: property_locale(prop, 'label'), admin_only: admin_only_for(prop) } }
      end.inject(:merge)
    end

    # @param property - property name
    # @param locale_key - valid keys are: label, help_text
    # @return [String] the value for the given locale
    def property_locale(property, locale_key)
      return property.to_s.capitalize unless locale_key.match(/(label|help_text)/)

      label = I18n.t("allinson_flex.#{context}.#{model}.#{locale_key}.#{property}")
      label = nil if label.include?('translation missing')
      label || send("#{locale_key}_for", property) || property.to_s.capitalize
    end

    def multiple?(value)
      !properties[value][:singular] if properties[value]
    end

    private

      def context_for(admin_set_id:)
        cxt = AllinsonFlex::Context.find_metadata_context_for(admin_set_id: admin_set_id)
        if cxt.blank?
          raise AllinsonFlex::NoAllinsonFlexContextError.new(
            "No Metadata Context for Admin Set #{admin_set_id}"
          )
        end
        @context = cxt.name
        @context_id = cxt.id
      end

      # Retrieve the given DynamicSchema for an existing work
      def dynamic_schema_for(context_id:, work_class_name:, dynamic_schema_id: nil)
        @dynamic_schema ||= if dynamic_schema_id.present?
                              AllinsonFlex::DynamicSchema.find(dynamic_schema_id)
                            else
                              AllinsonFlex::DynamicSchema.find_by(context_id: context_id, allinson_flex_class: work_class_name.to_s)
                            end
        if @dynamic_schema.nil?
          raise AllinsonFlex::NoAllinsonFlexSchemaError.new(
            "No Metadata Schema for ID #{dynamic_schema_id}, context #{context_id}, class #{work_class_name.to_s}"
          )
        end
      end

      def properties
        @properties ||= dynamic_schema.schema.deep_symbolize_keys![:properties]
      end

      def admin_only_for(property)
        property_hash_for(property)[:indexing]&.include?('admin_only')
      end

      def required_for(property)
        property if property_hash_for(property)[:required]
      end

      def locale_label_for(property)
        I18n.t("allinson_flex.#{context}.#{model}.labels.#{property}") ||
          label_for(property) ||
          property.to_s.capitalize
      end

      def label_for(property)
        property_hash_for(property)&.[](:display_label)
      end

      def help_text_for(property)
        property_hash_for(property)&.[](:usage_guidelines)
      end

      def property_hash_for(property)
        properties[property]
      end

      def default_indexing
        index_as('stored_searchable')
      end

      # @param indexing_key from the following list:
      #   displayable: ['_ssm'],
      #   facetable: ['_sim'],
      #   searchable: ['_teim','_dtim','_iim'],
      #   sortable: ['_tei','_si','_dti','_ii',
      #   stored_searchable: ['_tesim','_dtsim','_isim'],
      #   stored_sortable: ['_ssi','_dtsi'],
      #   symbol: ['_ssim']
      #
      # default behaviour is to return the string/text variant
      # @todo comine with data type to determine indexing value
      def index_as(indexing_key)
        case indexing_key
        when 'admin_only'
          nil
        when 'stored_searchable'
          '_tesim'
        when 'facetable'
          '_sim'
        when 'searchable'
          '_teim'
        when 'stored_sortable'
          '_ssi'
        when 'sortable'
          '_tei'
        when 'symbol'
          '_ssim'
        when 'displayable'
          '_ssm'
        else
          '_tesim'
        end
      end
  end
end
