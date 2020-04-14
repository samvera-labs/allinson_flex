# frozen_string_literal: true

module FlexibleMetadata
  class ProfileClassContext < ApplicationRecord
    self.table_name = 'm3_profile_classes_contexts'
    belongs_to :m3_profile_class, required: false, class_name: 'FlexibleMetadata::ProfileClass'
    belongs_to :m3_profile_context, required: false, class_name: 'FlexibleMetadata::ProfileContext'
  end
end
