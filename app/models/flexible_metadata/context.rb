# frozen_string_literal: true

module FlexibleMetadata
  class Context < ApplicationRecord
    self.table_name = 'flexible_metadata_contexts'

    belongs_to :m3_profile, class_name: 'FlexibleMetadata::Profile'
    belongs_to :m3_profile_context, class_name: 'FlexibleMetadata::ProfileContext'
    has_many :dynamic_schemas, foreign_key: 'flexible_metadata_context_id', dependent: :destroy
    serialize :admin_set_ids, Array
    validates :name, presence: true

    delegate :display_label, to: :m3_profile_context

    # @api public
    # @param admin_set_id [#to_s] the admin set to which we will scope our query.
    # @return [FlexibleMetadata::Context] that is active for the given administrative set`
    # @note using select here may not be performant if there are many contexts
    #   because the field is an array, using .where(admin_set_ids: ["#{query_term}"])
    #   will only work on exact matches
    def self.find_metadata_context_for(admin_set_id:)
      FlexibleMetadata::Context.select { |c| c.admin_set_ids.include?(admin_set_id) }.first || FlexibleMetadata::Context.where(name: 'default').first
    end

    # @api public
    # @return [Array] contexts for latest profile
    def self.available_contexts
      current = FlexibleMetadata::Profile.current_version
      current.blank? ? [] : current.flexible_metadata_contexts
    end
  end
end
