module FlexibleMetadata
  class ProfileAvailableProperty < ApplicationRecord
    self.table_name = 'm3_profile_available_properties'
    belongs_to :m3_profile_property, class_name: 'FlexibleMetadata::ProfileProperty', required: false
    belongs_to :available_on, polymorphic: true, required: false
  end
end
