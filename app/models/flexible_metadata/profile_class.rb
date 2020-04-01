module M3
  class ProfileClass < ApplicationRecord
    self.table_name = 'm3_profile_classes'

    # @todo any before_destroy validation?
    # many to many relationship between class and context
    has_and_belongs_to_many :contexts, class_name: 'M3::ProfileContext', foreign_key: 'm3_profile_class_id', association_foreign_key: 'm3_profile_context_id'
    has_many :available_properties, as: :available_on, class_name: 'M3::ProfileAvailableProperty', dependent: :destroy
    has_many :properties, through: :available_properties, source: :m3_profile_property
    has_many :class_texts, as: :textable, class_name: 'M3::ProfileText', dependent: :destroy
    accepts_nested_attributes_for :contexts, :class_texts

    validates :name, :display_label, presence: true

  end
end
