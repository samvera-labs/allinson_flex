# frozen_string_literal: true

module FlexibleMetadata
  class DynamicSchema < ApplicationRecord
    self.table_name = 'dynamic_schemas'

    belongs_to :flexible_metadata_context, class_name: 'FlexibleMetadata::Context'
    belongs_to :m3_profile, class_name: 'FlexibleMetadata::Profile'
    before_destroy :check_for_works
    serialize :schema, JSON
    validates :flexible_metadata_class, :schema, presence: true
    delegate :profile_version, to: :m3_profile

    private

      def check_for_works
        return if flexible_metadata_class.constantize.where(dynamic_schema: id.to_s).blank?
        errors.add(
          :base,
          "There are works using #{name}. This dynamic_schema cannot be deleted."
        )
        throw :abort
      end
  end
end
