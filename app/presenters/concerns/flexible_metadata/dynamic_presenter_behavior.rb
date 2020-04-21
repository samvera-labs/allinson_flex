# frozen_string_literal: true

module FlexibleMetadata
  module DynamicPresenterBehavior
    extend ActiveSupport::Concern

    included do
      class_attribute :model_class_name
      extend ClassMethods
      delegate(*delegated_properties, to: :solr_document)
    end

    module ClassMethods
      def delegated_properties
        FlexibleMetadata::DynamicSchemaService.default_properties(
          work_class_name: model_class_name
        )
      end
    end
  end
end
