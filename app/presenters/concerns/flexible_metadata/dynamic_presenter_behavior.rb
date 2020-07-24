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
  end
end
