# frozen_string_literal: true

class FlexibleMetadata::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc 'This generator installs FlexibleMetadata.'

  def banner
    say_status("info", "Generating FlexibleMetadata installation", :blue)
  end

  def add_gems
    gem 'webpacker'
    gem 'react-rails'

    Bundler.with_clean_env do
      run "bundle install"
    end
  end

  def mount_route
    route "mount FlexibleMetadata::Engine, at: '/'"
  end

  def create_config
    copy_file 'config/initializers/flexible_metadata.rb', 'config/initializers/flexible_metadata.rb'
  end

  def create_extensions
    directory 'lib/extensions', 'lib/extensions'

    file = 'config/application.rb'
    file_text = File.read(file)
    to_prepare = "      Dir.glob(File.join(File.dirname(__FILE__), '../lib/extensions/flexible_metadata_extensions.rb')) do |c|\n        Rails.configuration.cache_classes ? require(c) : load(c)\n      end"

    if file_text.include?('config.to_prepare')
      return if file_text.include?(to_prepare)
      insert_into_file file, after: /  config.to_prepare\n/ do
        "#{to_prepare}"
      end
    else
      insert_into_file file, before: /\n    # Settings in config/ do
        "\n    config.to_prepare do\n#{to_prepare}\n    end"
      end
    end
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

  def create_gitignore
    file = '.gitignore'
    File.write('.gitignore', "# ignore these files\n") unless File.exist?(file)
  end

  def create_react_javascript
    directory 'app/javascript', 'app/javascript'
  end

  def create_react_flash_messages
    file = 'app/views/_flash_msg.html.erb'
    return if File.exist? file
    copy_file File.join(Hyrax::Engine.root, file), file
  end

  def add_react_flash_messages
    file = 'app/views/_flash_msg.html.erb'
    file_text = File.read(file)
    flash = "\n<%= react_component 'flash_messages', messages: flash_messages %>\n"
    unless file_text.include?(flash)
      append_to_file file do
        flash
      end
    end
  end

  def add_javascript_pack_tag
    file = 'app/views/layouts/application.html.erb'
    file_text = File.read(file)
    pack = "    <%= javascript_pack_tag 'application' %>"

    return if file_text.include?(pack)
    insert_into_file file, before: /  <\/head>/ do
      "#{pack}\n"
    end
  end

  def add_helpers
    file = 'app/helpers/hyrax_helper.rb'
    file_text = File.read(file)
    helper = '  include FlexibleMetadata::FlexibleMetadataHelper'

    return if file_text.include?(helper)
    insert_into_file file, after: /HyraxHelperBehavior/ do
      "\n#{helper}"
    end
  end

  def add_gitignore
    lines = [
      '/public/packs',
      '/public/packs-test',
      '/node_modules',
      '/yarn-error.log',
      'yarn-debug.log*',
      '.yarn-integrity'
    ]
    file = '.gitignore'
    file_text = File.read(file)

    lines.each do |ignore|
      next if file_text.include?(ignore)
      append_to_file file do
        "#{ignore}\n"
      end
    end
  end

  def yarn_add_packages
    system 'yarn add @rjsf/core react-dom react-jsonschema-form react-jsonschema-form-bs4 react-spinners react-transition-group react_ujs immutability-helper'
    system 'yarn install'
  end

  def display_readme
    readme 'README'
  end
end
