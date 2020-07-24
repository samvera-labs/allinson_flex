# frozen_string_literal: true

module AllinsonFlex
  class ProfileClass < ApplicationRecord
    # @todo any before_destroy validation?
    # many to many relationship between class and context
    has_and_belongs_to_many :contexts, class_name: 'AllinsonFlex::ProfileContext', foreign_key: 'allinson_flex_profile_class_id', association_foreign_key: 'allinson_flex_profile_context_id'
    has_many :available_properties, as: :available_on, class_name: 'AllinsonFlex::ProfileAvailableProperty', dependent: :destroy
    has_many :properties, through: :available_properties, source: :allinson_flex_profile_property
    has_many :class_texts, as: :textable, class_name: 'AllinsonFlex::ProfileText', dependent: :destroy
    accepts_nested_attributes_for :contexts, :class_texts

    validates :name, :display_label, presence: true
  end
end
