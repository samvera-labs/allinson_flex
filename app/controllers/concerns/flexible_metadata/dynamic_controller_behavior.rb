
# override (from Hyrax 2.5.0) - new module
module M3
  module DynamicControllerBehavior
    extend ActiveSupport::Concern
    include M3Helper

    # @todo admin_set will be incoming with the work_type selection
    # Retrieve the dynamic_schema_service for the curation_concern
    def dynamic_schema_service
      @dynamic_schema_service ||= dynamic_schema_helper(
        curation_concern.admin_set_id,
        self.class.curation_concern_type.to_s,
        curation_concern.respond_to?(:dynamic_schema) ? curation_concern.dynamic_schema : nil
      )
    end
  end
end
