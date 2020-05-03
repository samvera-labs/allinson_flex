#  models
AdminSet.class_eval do
  include FlexibleMetadata::AdminSetBehavior
end

#  controllers
Hyrax::Admin::PermissionTemplatesController.prepend Extensions::FlexibleMetadata::PrependPermissionTemplatesController

#  forms
Hyrax::Forms::AdminSetForm.prepend Extensions::FlexibleMetadata::PrependAdminSetForm
Hyrax::Forms::PermissionTemplateForm.prepend Extensions::FlexibleMetadata::PrependPermissionTemplateForm