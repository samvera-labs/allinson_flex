# frozen_string_literal: true

## One AllinsonFlex::Profile per yaml file upload
#
require 'json_schemer'

module AllinsonFlex
  class Importer
    class_attribute :default_logger
    self.default_logger = Rails.logger
    class_attribute :default_config_file
    self.default_config_file = Dir[File.join(Rails.root, 'config', 'metadata_profile', '*.ya*ml').to_s].first # TODO: better solution that .first?

    def self.load_profile_from_path(path: '', logger: default_logger)
      profile_config_filename = File.exist?(path) ? path : default_config_file
      raise ProfileNotFoundError, "No profiles were found in #{path}" if profile_config_filename.blank?

      logger.info("Loading with profile from config/metadata_profile #{profile_config_filename}")
      generate_from_yaml_file(path: profile_config_filename, logger: default_logger)
    end

    def self.load_profile_from_data(profile_id: nil, data:, logger: default_logger)
      logger.info("Loading with form data")
      generate_from_hash(profile_id: profile_id, data: data)
    end

    # One profile per yaml file upload
    def construct
      AllinsonFlex::AllinsonFlexConstructor.find_or_create_from(
        profile_id: profile_id, 
        data: ActiveSupport::HashWithIndifferentAccess.new(data)
      )
    end

    private

      def self.generate_from_yaml_file(path:, logger: default_logger)
        data = YAML.load_file(path) if path =~ /.*\.ya*ml/
        raise YamlSyntaxError, "Invalid YAML syntax found in #{path}!" if data.nil?

        generate_from_hash(data: data)
      rescue Psych::SyntaxError => e
        logger.error("Invalid YAML syntax found in #{path}!")
        raise YamlSyntaxError, e.message
      end

      def self.generate_from_hash(profile_id: nil, data:)
        importer = new(profile_id: profile_id, data: data)
        profiles = importer.construct
        profiles
      end

      def initialize(profile_id:, data:, schema: default_schema, validator: default_validator, logger: default_logger)
        self.profile_id = profile_id
        self.data = data
        self.schema = schema
        self.validator = validator
        @logger = logger
        validate!
      end

      attr_reader :data, :logger

      attr_accessor :data, :validator, :schema, :profile_id

      def default_validator
        AllinsonFlex::Validator
      end

      def default_schema
        @schema_path    = Pathname.new(AllinsonFlex.m3_schema_path)
        @default_schema = JSONSchemer.schema(@schema_path)
        @default_schema
      end

      def validate!
        validator.validate(data: data, schema: schema, logger: logger)
      end

      class ProfileNotFoundError < StandardError; end
      class YamlSyntaxError < StandardError; end
  end
end
