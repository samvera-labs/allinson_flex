module FlexibleMetadata
  class DynamicSchema < ApplicationRecord
    belongs_to :flexible_metadata_context, class_name: 'FlexibleMetadata::Context'
    belongs_to :flexible_metadata_profile, class_name: 'FlexibleMetadata::Profile'
    before_destroy :check_for_works
    serialize :schema, JSON
    validates :flexible_metadata_class, :schema, presence: true
    delegate :profile_version, to: :flexible_metadata_profile

    private

    def check_for_works
      return if self.flexible_metadata_class.constantize.where(dynamic_schema: "#{self.id}").blank?
        errors.add(
          :base,
          "There are works using #{self.name}. This dynamic_schema cannot be deleted."
        )
        throw :abort
    end
  end
end
