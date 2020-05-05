# frozen_string_literal: true

require "webpacker/helper"
# override (from Hyrax 2.5.0) - new module
module FlexibleMetadataHelper

  include ::Webpacker::Helper
  def current_webpacker_instance
    FlexibleMetadata.webpacker
  end

  # Retrieve the selected context for the AdminSet
  def selected_context(admin_set)
    return '' if admin_set.metadata_context.blank?
    admin_set.metadata_context.id
  end

  # Setup the DynamicSchemaService
  # Retrieve the existing dynamic_schema for a saved object, or the latest for a new object
  # If it is not set, pass the DEFAULT_ID
  def dynamic_schema_helper(admin_set_id, work_class_name, dynamic_schema_id = nil)
    FlexibleMetadata::DynamicSchemaService.new(
      admin_set_id: admin_set_id || AdminSet::DEFAULT_ID,
      work_class_name: work_class_name,
      dynamic_schema_id: dynamic_schema_id
    )
  end

  def flash_messages
    flash.map do |type, text|
      { id: text.object_id, type: type, text: text }
    end
  end
end
