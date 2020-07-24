# frozen_string_literal: true

module AllinsonFlex
  class ProfileClassContext < ApplicationRecord
    belongs_to :flexible_metadata_profile_class, required: false, class_name: 'FlexibleMetadata::ProfileClass'
    belongs_to :flexible_metadata_profile_context, required: false, class_name: 'FlexibleMetadata::ProfileContext'
  end
end
