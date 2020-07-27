# frozen_string_literal: true

module AllinsonFlex
  class ProfileContext < ApplicationRecord
    # @todo any before_destroy validation?
    has_many :available_properties, as: :available_on, class_name: 'AllinsonFlex::ProfileAvailableProperty', dependent: :destroy
    has_many :properties, through: :available_properties, source: :profile_property
    has_many :context_texts, as: :textable, class_name: 'AllinsonFlex::ProfileText', dependent: :destroy
    accepts_nested_attributes_for :context_texts

    validates :name, :display_label, presence: true
  end
end
