module FlexibleMetadata
  class ProfileText < ApplicationRecord
    self.table_name = 'flexible_metadata_profile_texts'
    belongs_to :textable, polymorphic: true, required: false

    validates :name, :value, presence: true
  end
end
