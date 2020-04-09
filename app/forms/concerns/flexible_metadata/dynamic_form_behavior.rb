# frozen_string_literal: true

# override (from Hyrax 2.5.0) - new module
module FlexibleMetadata
  module DynamicFormBehavior
    extend ActiveSupport::Concern

    included do
      # Set the terms at class level to the full default set - this will be used to determine permitted parameters
      self.terms = FlexibleMetadata::DynamicSchemaService.default_properties(
        work_class_name: model_class.to_s
      )
      self.required_fields = []
    end

    # @todo - add to m3 generator
    # override (from Hyrax 2.5.0) - override the initializer:
    #   set the terms and required terms to those from the contextual schema
    def initialize(model, current_ability, controller)
      self.class.terms = controller.dynamic_schema_service.property_keys
      self.class.required_fields = controller.dynamic_schema_service.required_properties
      super(model, current_ability, controller)
    end
  end
end
