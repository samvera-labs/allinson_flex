# frozen_string_literal: true

# override (from Hyrax 2.5.0) - new module
module AllinsonFlex
  module DynamicIndexerBehavior
    extend ActiveSupport::Concern

    included do
      class_attribute :model_class
    end

    # override (from Hyrax 2.5.0) - provide custom generate_solr_document
    # Use the dynamic schema for indexing
    def generate_solr_document
      dynamic_schema_service = object.dynamic_schema_service

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
