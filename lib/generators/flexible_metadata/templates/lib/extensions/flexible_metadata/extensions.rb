#  models
AdminSet.class_eval do
  include FlexibleMetadata::AdminSetBehavior
end

#  controllers
Hyrax::Admin::PermissionTemplatesController.prepend FlexibleMetadata::PrependPermissionTemplatesController

#  forms
Hyrax::Forms::AdminSetForm.prepend FlexibleMetadata::PrependAdminSetForm
Hyrax::Forms::PermissionTemplateForm.prepend FlexibleMetadata::PrependPermissionTemplateForm