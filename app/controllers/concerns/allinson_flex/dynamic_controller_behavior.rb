# frozen_string_literal: true

# override (from Hyrax 2.5.0) - new module
module AllinsonFlex
  module DynamicControllerBehavior
    extend ActiveSupport::Concern
    include AllinsonFlexHelper

    included do
      helper_method :dynamic_schema_service
    end

    # Retrieve the dynamic_schema_service for the curation_concern
    def dynamic_schema_service
      return @dynamic_schema_service if @dynamic_schema_service
      # TODO ability to set schema upgrade manually, this always upgrades whenever a record is edited
      dynamic_schema_id = if action_name == 'edit' &&
                              request.controller_class.included_modules.include?(Hyrax::WorksControllerBehavior)
                            nil
                          else
                            curation_concern&.dynamic_schema_id
                          end
      @dynamic_schema_service = AllinsonFlex::DynamicSchemaService.new(
        admin_set_id: curation_concern&.admin_set_id || AdminSet::DEFAULT_ID,
        work_class_name: request.controller_class.curation_concern_type.to_s,
        dynamic_schema_id: dynamic_schema_id
      )
    end
  end
end