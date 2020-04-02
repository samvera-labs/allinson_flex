module M3
  class DynamicSchema < ApplicationRecord
    belongs_to :m3_context, class_name: 'M3::Context'
    belongs_to :m3_profile, class_name: 'M3::Profile'
    before_destroy :check_for_works
    serialize :schema, JSON
    validates :m3_class, :schema, presence: true
    delegate :profile_version, to: :m3_profile

    private

    def check_for_works
      return if self.m3_class.constantize.where(dynamic_schema: "#{self.id}").blank?
        errors.add(
          :base,
          "There are works using #{self.name}. This dynamic_schema cannot be deleted."
        )
        throw :abort
    end
  end
end
