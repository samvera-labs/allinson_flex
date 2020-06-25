# frozen_string_literal: true

# override (from Hyrax 2.5.0) - new module
module FlexibleMetadata
  module DynamicControllerBehavior
    extend ActiveSupport::Concern
    include FlexibleMetadataHelper

    # @todo admin_set will be incoming with the work_type selection
    # Retrieve the dynamic_schema_service for the curation_concern
    def dynamic_schema_service
      dynamic_schema_helper(
        curation_concern&.admin_set_id,
        self.class.curation_concern_type.to_s,
        curation_concern.dynamic_schema
      )
    end
  end
end
