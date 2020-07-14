# frozen_string_literal: true

require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root "./spec/test_app_templates"

  def install_hyrax
    generate 'hyrax:install', '-f'
  end

  def install_engine
    generate 'flexible_metadata:install'
  end

  # The following are not installed by the flexible_metadata generator
  #   install them here to configure the test_app

  def install_webpacker
    system './bin/rails webpacker:install'
  end

  def install_webpacker_react
    system './bin/rails webpacker:install:react'
  end

  def install_react
    system './bin/rails generate react:install'
  end
end
