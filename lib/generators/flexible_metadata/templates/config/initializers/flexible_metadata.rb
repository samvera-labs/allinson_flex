# frozen_string_literal: true

FlexibleMetadata.setup do |config|
  # Use a different base repository for the m3 json schema (eg. a fork)
  # Default:
  #
  # config.m3_schema_repository = 'https://raw.githubusercontent.com/samvera-labs/houndstooth'

  # Use a different version (eg. commit hash)
  # Default:
  #
  # config.m3_schema_version_tag = 'f753864727a0ba743cb5ec47e88797435a0a596a'
end

#  models
AdminSet.class_eval do
  include FlexibleMetadata::AdminSetBehavior
end

#  controllers
Hyrax::Admin::PermissionTemplatesController.prepend ::FlexibleMetadata::PrependPermissionTemplatesController

#  forms
Hyrax::Forms::AdminSetForm.prepend ::FlexibleMetadata::PrependAdminSetForm
Hyrax::Forms::PermissionTemplateForm.prepend ::FlexibleMetadata::PrependPermissionTemplateForm
