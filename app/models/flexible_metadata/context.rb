# frozen_string_literal: true

module FlexibleMetadata
  class Context < ApplicationRecord
    self.table_name = 'flexible_metadata_contexts'

    belongs_to :m3_profile, class_name: 'FlexibleMetadata::Profile'
    belongs_to :m3_profile_context, class_name: 'FlexibleMetadata::ProfileContext'
    has_many :dynamic_schemas, foreign_key: 'flexible_metadata_context_id', dependent: :destroy
    serialize :admin_set_ids, Array
    validates :name, presence: true
    before_create :update_admin_sets

    delegate :display_label, to: :m3_profile_context

    # @api public
    # @param admin_set_id [#to_s] the admin set to which we will scope our query.
    # @return [FlexibleMetadata::Context] that is active for the given administrative set`
    # @note where.not combined with select because the field is an array, so
    #   using .where(admin_set_ids: ["#{query_term}"])
    #   will only work on exact matches
    def self.find_metadata_context_for(admin_set_id:)
      FlexibleMetadata::Context.order("created_at asc").where.not(admin_set_ids: [nil, []]).select { |c| c.admin_set_ids.include?(admin_set_id) }.last || FlexibleMetadata::Context.where(name: 'default').order('created_at').last
    end

    # @api public
    # @return [Array] contexts for latest profile
    def self.available_contexts
      current = FlexibleMetadata::Profile.current_version
      current.blank? ? [] : current.flexible_metadata_contexts
    end

    # Add the admin_set id to the new context so that when we grab the contexts for the admin set
    #  the most recent gets returned
    def update_admin_sets
      existing_contexts = FlexibleMetadata::Context.unscoped.where(name: self.name)
      existing_admin_set_ids = existing_contexts.map {|a| a.admin_set_ids}.flatten.uniq
      if existing_admin_set_ids.present?
        self.admin_set_ids ||= []
        self.admin_set_ids = (self.admin_set_ids + existing_admin_set_ids).uniq
      end
    end
  end
end
