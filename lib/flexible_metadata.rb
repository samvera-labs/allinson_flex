# frozen_string_literal: true

require "flexible_metadata/engine"
require 'active_support/all'

module FlexibleMetadata
  class << self
    mattr_accessor  :m3_schema_repository_raw,
                    :m3_schema_version_tag

    self.m3_schema_repository_raw = 'https://raw.githubusercontent.com/samvera-labs/houndstooth'
    self.m3_schema_version_tag = 'f753864727a0ba743cb5ec47e88797435a0a596a'
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
  end

  def self.mk_m3_schema_path
    FileUtils.mkdir_p(m3_schema_base_path)
  end

  def self.setup
    yield self
  end
end
