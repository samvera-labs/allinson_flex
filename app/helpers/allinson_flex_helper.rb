# frozen_string_literal: true

require "webpacker/helper"
# override (from Hyrax 2.5.0) - new module
module AllinsonFlexHelper

  include ::Webpacker::Helper
  def current_webpacker_instance
    AllinsonFlex.webpacker
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
    AllinsonFlex::DynamicSchemaService.new(
      admin_set_id: admin_set_id || AdminSet::DEFAULT_ID,
      work_class_name: work_class_name,
      dynamic_schema_id: dynamic_schema_id
    )
  end

  # borrowd from batch-importer https://github.com/samvera-labs/hyrax-batch_ingest/blob/master/app/controllers/hyrax/batch_ingest/batches_controller.rb
  def available_admin_sets
    # Restrict available_admin_sets to only those current user can desposit to.
    @available_admin_sets ||= Hyrax::Collections::PermissionsService.source_ids_for_deposit(ability: current_ability, source_type: 'admin_set').map do |admin_set_id|
      [AdminSet.find(admin_set_id).title.first, admin_set_id]
    end
  end

  def flash_messages
    flash.map do |type, text|
      { id: text.object_id, type: type, text: text }
    end
  end
end
