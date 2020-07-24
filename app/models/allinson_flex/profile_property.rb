# frozen_string_literal: true

module AllinsonFlex
  class ProfileProperty < ApplicationRecord
    self.table_name = 'flexible_metadata_profile_properties'

    before_destroy :check_for_works
    has_many :available_properties, class_name: 'FlexibleMetadata::ProfileAvailableProperty', foreign_key: 'flexible_metadata_profile_property_id', dependent: :destroy
    has_many :available_on_classes, through: :available_properties, source: :available_on, source_type: 'FlexibleMetadata::ProfileClass'
    has_many :available_on_contexts, through: :available_properties, source: :available_on, source_type: 'FlexibleMetadata::ProfileContext'
    has_many :texts, class_name: 'FlexibleMetadata::ProfileText', foreign_key: 'flexible_metadata_profile_property_id', dependent: :destroy
    accepts_nested_attributes_for :texts, allow_destroy: true

    serialize :indexing, Array
    validates :name, presence: true
    validate :validate_indexing

    # array of valid values for indexing
    INDEXING = %w[displayable
                  facetable
                  searchable
                  sortable
                  stored_searchable
                  stored_sortable
                  symbol
                  fulltext_searchable].freeze

    private

      # validate indexing is included in INDEXING
      def validate_indexing
        self.indexing = ['stored_searchable'] if indexing.blank?
        indexing.each do |i|
          errors.add(:indexing, "#{i} is not a valid indexing term") unless INDEXING.include? i
        end
      end

      # this is a crap query as it will basically return EVERYTHING
      def check_for_works
        works = available_on_classes.map do |model|
          model.name.constantize.where(
            name.to_sym => '*'
          ).flatten.reject { |res| res.send(name).blank? }
        end.flatten

        # if there are no works, carry on and destroy
        return if works.blank?
        errors.add(
          :base,
          "There are #{works.length} works using #{name}. This property cannot be deleted."
        )
        throw :abort
      end
  end
end
