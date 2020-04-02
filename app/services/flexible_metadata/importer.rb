## One FlexibleMetadata::Profile per yaml file upload
#
require 'json_schemer'

module FlexibleMetadata
  class Importer
    class_attribute :default_logger
    self.default_logger = Rails.logger
    class_attribute :default_config_file
    self.default_config_file = Dir["#{File.join(Rails.root, 'config', 'metadata_profiles', '*.ya*ml')}"].first # TODO: better solution that .first?

    def self.load_profile_from_path(path: '', logger: default_logger)
      profile_config_filename = File.exist?(path) ? path : default_config_file
      raise ProfileNotFoundError, "No profiles were found in #{path}" if profile_config_filename.blank?

      logger.info("Loading with profile config #{profile_config_filename}")
      generate_from_yaml_file(path: profile_config_filename, logger: default_logger)
    end

    # One profile per yaml file upload
    def construct
      FlexibleMetadata::FlexibleMetadataConstructor.find_or_create_from(name: name, data: data)
    end

    private

    def self.generate_from_yaml_file(path:, logger: default_logger)
      name = File.basename(path, '.*')
      data = YAML.load_file(path) if path =~ /.*\.ya*ml/
      raise YamlSyntaxError, "Invalid YAML syntax found in #{path}!" if data.nil?

      generate_from_hash(name: name, data: data)
    rescue Psych::SyntaxError => e
      logger.error("Invalid YAML syntax found in #{path}!")
      raise YamlSyntaxError, e.message
    end

    def self.generate_from_hash(name:, data:)
      importer = new(name: name, data: data)
      profiles = importer.construct
      profiles
    end

    def initialize(name:, data:, schema: default_schema, validator: default_validator, logger: default_logger)
      self.name = name
      self.data = data
      self.schema = schema
      self.validator = validator
      @logger = logger
      validate!
    end

    attr_reader :data, :logger

    attr_accessor :name, :data, :validator, :schema

    def default_validator
      FlexibleMetadata::Validator
    end

    def default_schema
      @schema_path    = Pathname.new('flexible_metadata_profile_schema.json')
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
