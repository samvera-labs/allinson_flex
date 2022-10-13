# frozen_string_literal: true

# override (from Hyrax 2.5.0) - new module
module AllinsonFlex
  module DynamicMetadataBehavior
    extend ActiveSupport::Concern

    included do
      property :dynamic_schema_id, predicate: ::RDF::URI("https://github.com/samvera-labs/houndstooth"), multiple: false
      property :profile_version, predicate: ::RDF::URI("https://github.com/samvera-labs/houndstooth#version"), multiple: false
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
      load_allinson_flex ## This is the new part
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
      load_allinson_flex  ## This is the new part
      load_attached_files
      run_callbacks :find
      run_callbacks :initialize
      self
    end

    def load_allinson_flex
      dynamic_schema.schema['properties'].each do |prop, value|
        predicate = value['predicate'].presence || "https://localhost/#{prop}"
        self.class.late_add_property prop.to_sym, predicate: predicate, multiple: !value['singular']
      end
      self.class.type(AllinsonFlex::DynamicSchemaService.rdf_type(work_class_name: self.class.to_s))
      # Reset attribute names so they are regenerated correctly
      self.class.instance_variable_set("@attribute_names", nil)
    end

    def dynamic_schema
      @dynamic_schema ||= AllinsonFlex::DynamicSchema.find_by_id(id: self.dynamic_schema_id) || self.dynamic_schema_service(update: true)&.dynamic_schema
    end

    def dynamic_schema=(value)
      @dynamic_schema = value
      self.dynamic_schema_id = value.id
      self.profile_version = value.profile_version.to_f
    end

    # Setup dynamic schema service
    def dynamic_schema_service(args = {})
      # clear memoizaiton when as_id changes
      old_as_id = @as_id
      
      @as_id = args[:as_id] || try(:admin_set_id) || AdminSet::DEFAULT_ID
      @dynamic_schema_service = nil if old_as_id != @as_id

      # If we want to update, dont pass an existing id in
      old_update = @dynamic_schema_update
      @dynamic_schema_update = args[:update]
      @dynamic_schema_service = nil if old_update != @dynamic_schema_update
      schema_id = args[:update] ? nil : self.dynamic_schema_id

      @dynamic_schema_service ||= AllinsonFlex::DynamicSchemaService.new(
        admin_set_id: @as_id,
        work_class_name: self.class.to_s,
        dynamic_schema_id: schema_id
      )
    end
  end
end
