# frozen_string_literal: true

module AllinsonFlex
  class ProfileClass < ApplicationRecord
    # @todo any before_destroy validation?
    # many to many relationship between class and context
    #   Note: this seems incorrect, as has_and_belongs_to_many is not defined on both models, 
    #   and additionally there is a defined table, ProfileClassContext as the intersection of these two classes.
    has_and_belongs_to_many :profile_contexts # this seems incorrect??
    has_many :available_properties, as: :available_on, class_name: 'AllinsonFlex::ProfileAvailableProperty', dependent: :destroy
    has_many :properties, through: :available_properties, source: :profile_property
    has_many :class_texts, as: :textable, class_name: 'AllinsonFlex::ProfileText', dependent: :destroy
    accepts_nested_attributes_for :profile_contexts, :class_texts

    validates :name, :display_label, presence: true
  end
end
