# frozen_string_literal: true

module AllinsonFlex
  module DynamicPresenterBehavior
    extend ActiveSupport::Concern

    included do
      class_attribute :model_class
      extend ClassMethods
    end

    module ClassMethods
      def delegated_properties
        AllinsonFlex::DynamicSchemaService.default_properties(
          work_class_name: model_class.to_s
        )
      end
    end

    def admin_set_id
      @admin_set_id ||= Hyrax::SolrService.query("title_tesim:\"#{self.admin_set.first}\"", rows: 1, fl: 'id').first['id']
    end

    def dynamic_schema_service
      return @dynamic_schema_service if @dynamic_schema_service
      # Reload the delegation since that was done at the class level and may have changed
      self.class.delegate(*self.class.delegated_properties, to: :solr_document)
      @dynamic_schema_service = AllinsonFlex::DynamicSchemaService.new(
        admin_set_id: (admin_set_id || AdminSet::DEFAULT_ID),
        work_class_name: self.class.model_class.to_s,
        dynamic_schema_id: self.dynamic_schema_id
      )
    end
  end
end
