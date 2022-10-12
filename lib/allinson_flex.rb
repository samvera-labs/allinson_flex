# frozen_string_literal: true

require "allinson_flex/engine"
require 'active_support/all'

module AllinsonFlex
  ROOT_PATH = Pathname.new(File.join(__dir__, ".."))

  class << self
    mattr_accessor  :m3_schema_repository_raw,
                    :m3_schema_version_tag

    self.m3_schema_repository_raw = 'https://raw.githubusercontent.com/samvera-labs/houndstooth'
    self.m3_schema_version_tag = 'main'

    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join("config/webpacker.yml")
      )
    end
  end

  def self.m3_schema_path
    retrieve_schema unless File.exist?(m3_schema_full_path)
    m3_schema_full_path
  end

  def self.m3_schema_full_path
    File.join(m3_schema_base_path, m3_schema_filename)
  end

  def self.m3_schema_base_path
    File.join('config', 'm3_json_schemas', m3_schema_version_tag)
  end

  def self.m3_schema_filename
    'm3_json_schema.json'
  end

  def self.m3_schema_uri
    File.join(m3_schema_repository_raw, m3_schema_version_tag, m3_schema_filename)
  end

  def self.retrieve_schema
    mk_m3_schema_path
    require 'open-uri'
    open(m3_schema_full_path, 'wb') { |f| f << open(m3_schema_uri).read }
  rescue
  end

  def self.mk_m3_schema_path
    FileUtils.mkdir_p(m3_schema_base_path)
  end

  def self.setup
    yield self
  end
end
