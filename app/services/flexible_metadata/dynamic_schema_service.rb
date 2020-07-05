# frozen_string_literal: true

require 'active_support/core_ext/hash/keys'
module FlexibleMetadata
  # @todo move custom error classes to a single location
  class NoFlexibleMetadataContextError < StandardError; end

  class DynamicSchemaService
    attr_accessor :dynamic_schema, :flexible_metadata_context, :flexible_metadata_context_id, :model

    class << self
      # Retrieve the properties for the model / work type
      # this takes in to account an admin_set and or context
      # if one is available.
      # @return [Hash] property => opts
      def model_properties(concern:)
        sch = schema(work_class_name: concern.class.to_s, context: concern.admin_set&.metadata_context)['properties']
        model_props = {}
        unless sch.blank?
          model_props = sch.map do |prop_name, prop_value|
            { prop_name.to_sym => {
              predicate: predicate_for(predicate_uri: prop_value['predicate'] || "http://example.com/#{prop_name}"),
              multiple: prop_value['singular'] == false
            } }
          end.inject(:merge)
          model_props[:dynamic_schema] = dynamic_schema_property
        end
        model_props
      end

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
        props << :dynamic_schema
        props
      rescue StandardError => e
        []
      end

      # Retrieve the latest default dynamic_schema
      def schema(work_class_name:, context: nil)
        context ||= FlexibleMetadata::Context.where(name: 'default')
        FlexibleMetadata::DynamicSchema.where(
          flexible_metadata_class: work_class_name,
          flexible_metadata_context: context
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
        flexible_metadata_context_id: flexible_metadata_context_id,
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
                                  "#{prop_name}#{index_as(indexing_key)}"
                                end
        end
      end
      indexers[:dynamic_schema] = ['dynamic_schema_tesim']
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
        { prop => { label: property_locale(prop, 'label') } }
      end.inject(:merge)
    end

    # @param property - property name
    # @param locale_key - valid keys are: label, help_text
    # @return [String] the value for the given locale
    def property_locale(property, locale_key)
      return property.to_s.capitalize unless locale_key.match('label' || 'help_text')

      label = I18n.t("flexible_metadata.#{flexible_metadata_context}.#{model}.#{locale_key}.#{property}")
      label = nil if label.include?('translation missing')
      label || send("#{locale_key}_for", property) || property.to_s.capitalize
    end

    private

      def context_for(admin_set_id:)
        cxt = AdminSet.find(admin_set_id).metadata_context
        if cxt.blank?
          raise FlexibleMetadata::NoFlexibleMetadataContextError(
            "No Metadata Context for Admin Set #{admin_set_id}"
          )
        end
        @flexible_metadata_context = cxt.name
        @flexible_metadata_context_id = cxt.id
      end

      # Retrieve the given DynamicSchema for an existing work
      def dynamic_schema_for(flexible_metadata_context_id:, work_class_name:, dynamic_schema_id: nil)
        @dynamic_schema ||= if dynamic_schema_id.present?
                              FlexibleMetadata::DynamicSchema.find(dynamic_schema_id)
                            else
                              FlexibleMetadata::DynamicSchema.where(flexible_metadata_context: flexible_metadata_context_id).select do |ds|
                                ds.flexible_metadata_class == work_class_name.to_s
                              end.first
                            end
      end

      def properties
        @properties ||= dynamic_schema.schema.deep_symbolize_keys![:properties]
      end

      def required_for(property)
        property if property_hash_for(property)[:required]
      end

      def locale_label_for(property)
        I18n.t("flexible_metadata.#{flexible_metadata_context}.#{model}.labels.#{property}") ||
          label_for(property) ||
          property.to_s.capitalize
      end

      def label_for(property)
        property_hash_for(property)[:display_label]
      end

      def help_text_for(property)
        property_hash_for(property)[:usage_guidelines]
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
        when 'stored_searchable'
          '_tesim'
        when 'facetable'
          '_ssm'
        when 'searchable'
          '_teim'
        when 'stored_sortable'
          '_ssi'
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
