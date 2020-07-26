# frozen_string_literal: true

# override (from Hyrax 2.5.0) - new module
module FlexibleMetadata
  module DynamicMetadataBehavior
    extend ActiveSupport::Concern

    included do
      property :dynamic_schema, predicate: ::RDF::URI("https://github.com/samvera-labs/houndstooth"), multiple: false
    end

    class_methods do
      # It appears to be safe to add w/o removing first
      # Index blocks are not supported here
      def late_add_property(name, properties)
        raise ArgumentError, "You must provide a `:predicate' option to property" unless properties.key?(:predicate)
        # Logic stolen from ActiveFedora property class method
        properties = { multiple: true }.merge(properties)
        # always recreate the delegated attributes class in case of property changes
        delegated_attributes[name] = ActiveFedora::ActiveTripleAttribute.new(name, properties)
        reflection = ActiveFedora::Attributes::PropertyBuilder.build(self, name, properties)
        ActiveTriples::Reflection.add_reflection self, name, reflection
        # stolen from GeneragedResourceSchmeStrategy to clear out the generaged resource class being out of sync
        if @generated_resource_class
          @generated_resource_class.property name, properties
        end
        true
      end

      # name - string name of property
      # TODO - we are not using this right now, but its a good start to something hard to figure out
      def late_remove_property(name)
        name_string = name.to_s
        # remove from delegated_attributes
        self.delegated_attributes = self.delegated_attributes.except(name)
        # Remove from ActiveTriples reflections
        self.properties = self.properties.except(name)
      end
    end

    # Override ActiveFedora::Core 11.5.5 to include flexible metadata load
    def initialize(attributes = nil, &_block)
      init_internals
      attributes = attributes.dup if attributes # can't dup nil in Ruby 2.3
      id = attributes && (attributes.delete(:id) || attributes.delete('id'))
      @ldp_source = build_ldp_resource(id)
      raise IllegalOperation, "Attempting to recreate existing ldp_source: `#{ldp_source.subject}'" unless ldp_source.new?
      load_flexible_metadata ## This is the new part
      assign_attributes(attributes) if attributes
      assert_content_model
      load_attached_files

      yield self if block_given?
      _run_initialize_callbacks
    end

    # Override ActiveFedora::Core 11.5.5 to include flexible metadata load
    def init_with_resource(rdf_resource)
      init_internals
      @ldp_source = rdf_resource
      load_flexible_metadata  ## This is the new part
      load_attached_files
      run_callbacks :find
      run_callbacks :initialize
      self
    end

    def load_flexible_metadata
      base_dynamic_schema.schema['properties'].each do |prop, value|
        predicate = value['predicate'].presence || "https://localhost/#{prop}"
        self.class.late_add_property prop.to_sym, predicate: predicate, multiple: !value['singular']
      end
      self.class.type(FlexibleMetadata::DynamicSchemaService.rdf_type(work_class_name: self.class.to_s))
    end

    # Retrieve the dynamic schema
    def base_dynamic_schema(args = {})
      dynamic_schema_service(args).dynamic_schema
    end

    # Setup dynamic schema service
    def dynamic_schema_service(args = {})
      # clear memoizaiton when as_id changes
      old_as_id = @as_id
      @as_id = args[:as_id] || admin_set_id || AdminSet::DEFAULT_ID
      @dynamic_schema_service = nil if old_as_id != @as_id
      schema_id = args[:update] ? nil : self.dynamic_schema
      @dynamic_schema_service ||= FlexibleMetadata::DynamicSchemaService.new(
        admin_set_id: @as_id,
        work_class_name: self.class.to_s,
        dynamic_schema_id: schema_id
      )
    end
  end
end
