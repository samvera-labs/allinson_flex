# frozen_string_literal: true

module AllinsonFlex
  class DynamicSchema < ApplicationRecord
    belongs_to :context
    belongs_to :profile
    before_destroy :check_for_works
    serialize :schema, JSON
    validates :allinson_flex_class, :schema, presence: true
    delegate :profile_version, to: :profile

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
