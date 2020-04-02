module FlexibleMetadata
  class ProfileClass < ApplicationRecord
    self.table_name = 'flexible_metadata_profile_classes'

    # @todo any before_destroy validation?
    # many to many relationship between class and context
    has_and_belongs_to_many :contexts, class_name: 'FlexibleMetadata::ProfileContext', foreign_key: 'flexible_metadata_profile_class_id', association_foreign_key: 'flexible_metadata_profile_context_id'
    has_many :available_properties, as: :available_on, class_name: 'FlexibleMetadata::ProfileAvailableProperty', dependent: :destroy
    has_many :properties, through: :available_properties, source: :flexible_metadata_profile_property
    has_many :class_texts, as: :textable, class_name: 'FlexibleMetadata::ProfileText', dependent: :destroy
    accepts_nested_attributes_for :contexts, :class_texts

    validates :name, :display_label, presence: true

  end
end
