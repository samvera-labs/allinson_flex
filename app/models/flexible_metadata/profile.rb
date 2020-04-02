module FlexibleMetadata
  class Profile < ApplicationRecord
    self.table_name = 'm3_profiles'

    before_destroy :check_for_works
    # flexible metadata objects
    has_many :flexible_metadata_contexts, class_name: 'FlexibleMetadata::Context', foreign_key: 'm3_profile_id', dependent: :destroy
    has_many :dynamic_schemas, class_name: 'FlexibleMetadata::DynamicSchema', foreign_key: 'm3_profile_id', dependent: :destroy
    # profile elements
    has_many :classes, class_name: 'FlexibleMetadata::ProfileClass', foreign_key: 'm3_profile_id', dependent: :destroy
    has_many :contexts, class_name: 'FlexibleMetadata::ProfileContext', foreign_key: 'm3_profile_id', dependent: :destroy
    has_many :properties, class_name: 'FlexibleMetadata::ProfileProperty', foreign_key: 'm3_profile_id', dependent: :destroy
    accepts_nested_attributes_for :classes, :contexts, :properties
    # serlializations
    serialize :profile
    # validations
    validates :name, :profile_version, :responsibility, presence: true
    validates :profile_version, uniqueness: true
    # callbacks
    before_create :add_date_modified, :add_m3_version
    after_create :add_profile_data

    attr_accessor :profile_data

    def self.current_version
      FlexibleMetadata::Profile.order("created_at asc").last
    end

    def available_classes
      # must be associated with a work
      Hyrax.config.curation_concerns.map(&:to_s)
    end

    # @todo, extend to full set in FlexibleMetadata
    def available_text_names
      [
        ['Display Label', 'display_label']
      ]
    end

    # @todo - don't save unchanged profiles as new records
    def set_profile_version
      profile_version ? self.profile_version += 1 : self.profile_version = 1
      # if we already have this version,
      #    compare the data,
      #    if it's the same,
      #      do nothing;
      #    if it's different
      #      return an error "This version already exists,
      #        please increment the version number"
      # else
      #  update version attribute by 1
      # end
    end

    def add_date_modified
      self.date_modified = DateTime.now.strftime('%Y-%m-%d') if date_modified.blank?
    end

    # @todo make this configurable
    def add_m3_version
      self.m3_version = '1.0.beta2'.freeze
    end

    def add_profile_data
      data = profile_data
      self.profile = data unless profile == data
    end

    def profile_data
      @profile_data ||= FlexibleMetadata::FlexibleMetadataConstructor.build_profile_data(
        profile: self
      )
    end

    def gather_errors
      self.errors[:base] + properties_errors + contexts_errors + classes_errors
    end

    private

    def properties_errors
      self.properties.collect { |p| p.errors[:base] unless p.errors[:base].blank? }.compact.flatten
    end

    def contexts_errors
      self.classes.collect { |cl| cl.errors[:base] unless cl.errors[:base].blank? }.compact.flatten
    end

    def classes_errors
      self.contexts.collect { |cxt| cxt.errors[:base] unless cxt.errors[:base].blank? }.compact.flatten
    end

    def check_for_works
      flexible_metadata_contexts.each do |flexible_metadata_context|
        flexible_metadata_context.admin_set_ids.each do |admin_set_id|
          next unless AdminSet.find(admin_set_id).members.count > 0
          errors.add(
            :base,
            'A Profile with associated works cannot be destroyed.'
          )
          throw :abort
        end
      end
    end

  end
end