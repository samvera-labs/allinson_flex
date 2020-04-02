module FlexibleMetadata
  class ProfileClassContext < ApplicationRecord
    self.table_name = 'flexible_metadata_profile_classes_contexts'
    belongs_to :flexible_metadata_profile_class, required: false, class_name: 'FlexibleMetadata::ProfileClass'
    belongs_to :flexible_metadata_profile_context, required: false, class_name: 'FlexibleMetadata::ProfileContext'
  end
end
