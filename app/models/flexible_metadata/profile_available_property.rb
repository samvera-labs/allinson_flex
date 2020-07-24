# frozen_string_literal: true

module FlexibleMetadata
  class ProfileAvailableProperty < ApplicationRecord
    belongs_to :flexible_metadata_profile_property, class_name: 'FlexibleMetadata::ProfileProperty', required: false
    belongs_to :available_on, polymorphic: true, required: false
  end
end
