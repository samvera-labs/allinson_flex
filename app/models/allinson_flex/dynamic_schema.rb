# frozen_string_literal: true

module AllinsonFlex
  class DynamicSchema < ApplicationRecord
    belongs_to :allinson_flex_context, class_name: 'AllinsonFlex::Context'
    belongs_to :allinson_flex_profile, class_name: 'AllinsonFlex::Profile'
    before_destroy :check_for_works
    serialize :schema, JSON
    validates :allinson_flex_class, :schema, presence: true
    delegate :profile_version, to: :allinson_flex_profile

    private

      def check_for_works
        return if allinson_flex_class.constantize.where(dynamic_schema_tesim: id.to_s).blank?
        errors.add(
          :base,
          "There are works using #{name}. This dynamic_schema cannot be deleted."
        )
        throw :abort
      end
  end
end
