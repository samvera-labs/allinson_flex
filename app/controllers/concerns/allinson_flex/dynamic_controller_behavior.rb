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
      if action_name == 'edit' &&
          request.controller_class.included_modules.include?(Hyrax::WorksControllerBehavior)
        @dynamic_schema_service = curation_concern&.dynamic_schema_service(update: true)
      else
        @dynamic_schema_service = curation_concern&.dynamic_schema_service
      end
    end
  end
end
