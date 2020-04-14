# frozen_string_literal: true

module FlexibleMetadata
  class ProfileContext < ApplicationRecord
    self.table_name = 'm3_profile_contexts'
    # @todo any before_destroy validation?
    has_many :available_properties, as: :available_on, class_name: 'FlexibleMetadata::ProfileAvailableProperty', dependent: :destroy
    has_many :properties, through: :available_properties, source: :m3_profile_property
    has_many :context_texts, as: :textable, class_name: 'FlexibleMetadata::ProfileText', dependent: :destroy
    accepts_nested_attributes_for :context_texts

    validates :name, :display_label, presence: true
  end
end
