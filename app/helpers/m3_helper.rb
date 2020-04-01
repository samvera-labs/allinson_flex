# override (from Hyrax 2.5.0) - new module
module M3Helper

  # Retrieve the selected context for the AdminSet
  def selected_context(admin_set)
    return '' if admin_set.metadata_context.blank?
    admin_set.metadata_context.id
  end

  # Setup the DynamicSchemaService
  # Retrieve the existing dynamic_schema for a saved object, or the latest for a new object
  def dynamic_schema_helper(admin_set_id, work_class_name, dynamic_schema_id = nil)
    M3::DynamicSchemaService.new(
      admin_set_id: admin_set_id,
      work_class_name: work_class_name,
      dynamic_schema_id: dynamic_schema_id
    )
  end
end
