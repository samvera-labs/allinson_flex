module M3
  class ProfileClassContext < ApplicationRecord
    self.table_name = 'm3_profile_classes_contexts'
    belongs_to :m3_profile_class, required: false, class_name: 'M3::ProfileClass'
    belongs_to :m3_profile_context, required: false, class_name: 'M3::ProfileContext'
  end
end
