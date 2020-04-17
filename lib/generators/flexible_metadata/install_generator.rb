# frozen_string_literal: true

class FlexibleMetadata::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc 'This generator installs FlexibleMetadata.'

  def banner
    say_status("info", "Generating FlexibleMetadata installation", :blue)
  end

  def mount_route
    route "mount FlexibleMetadata::Engine, at: '/'"
  end

  def create_config
    copy_file 'config/initializers/flexible_metadata.rb', 'config/initializers/flexible_metadata.rb'
  end

  def add_ability
    file = 'app/models/ability.rb'
    file_text = File.read(file)
    ability = 'include FlexibleMetadata::Ability'
    return if file_text.include?(ability)
    insert_into_file file, after: /  include Hyrax::Ability\n/ do
      "  #{ability}\n"
    end
  end

  def add_javascripts
    file = 'app/assets/javascripts/application.js'
    file_text = File.read(file)
    js = '//= require flexible_metadata/application'

    return if file_text.include?(js)
    insert_into_file file, before: /\/\/= require_tree ./ do
      "#{js}\n"
    end
  end

  def create_metadata_profile_dir
    directory 'config/metadata_profile', 'config/metadata_profile'
  end

  def create_default_schema
    FlexibleMetadata.retrieve_schema
  end

  def display_readme
    readme 'README'
  end
end
