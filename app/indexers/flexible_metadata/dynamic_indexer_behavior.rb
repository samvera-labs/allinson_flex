# override (from Hyrax 2.5.0) - new module
module M3
  module DynamicIndexerBehavior

    # override (from Hyrax 2.5.0) - provide custom generate_solr_document
    # Use the dynamic schema for indexing
    def generate_solr_document
      dynamic_schema_service = M3::DynamicSchemaService.new(
        admin_set_id: object.admin_set_id,
        work_class_name: self.class.model_class.to_s
      )
      super.tap do |solr_doc|
        dynamic_schema_service.indexing_properties.each_pair do |prop_name, prop_value|
          prop_value.each do |index_value|
            solr_doc[index_value] = object.send(prop_name)
          end
        end
      end
    end
  end
end
