# frozen_string_literal: true

# override (from Hyrax 2.5.0) - new module
module AllinsonFlex
  module DynamicFormBehavior
    extend ActiveSupport::Concern

    included do
      class_attribute :base_terms
      attr_accessor :dynamic_schema_service

      # base terms that are not basic_metadata
      # @see https://github.com/samvera/hyrax/blob/master/app/forms/hyrax/forms/work_form.rb
      self.base_terms = [:title, :profile_version, :representative_id, :thumbnail_id, :rendering_ids, :files,
                         :visibility_during_embargo, :embargo_release_date, :visibility_after_embargo,
                         :visibility_during_lease, :lease_expiration_date, :visibility_after_lease,
                         :visibility, :ordered_member_ids, :source, :in_works_ids,
                         :member_of_collection_ids, :admin_set_id, :profile_version]

     self.required_fields = []
    end

    class_methods do
      def sanitize_params(form_params)
        admin_set_id = form_params[:admin_set_id]
        build_dynamic_permitted_params(admin_set_id)
        return super if admin_set_id && workflow_for(admin_set_id: admin_set_id).allows_access_grant?
        params_without_permissions = permitted_params.reject { |arg| arg.respond_to?(:key?) && arg.key?(:permissions_attributes) }
        form_params.permit(*params_without_permissions)
      end

      def build_dynamic_permitted_params(admin_set_id)
        # this always means the "latest" schema is used
        dynamic_schema_service = AllinsonFlex::DynamicSchemaService.new(
          admin_set_id: admin_set_id,
          work_class_name: self.model_class
        )

        terms = (dynamic_schema_service.property_keys + self.base_terms).uniq
        permitted = []
        terms.each do |term|
          if multiple?(term)
            permitted << { term => [] }
          else
            permitted << term
          end
        end
        @permitted = permitted + [
          :on_behalf_of,
          :version,
          :add_works_to_collection,
          {
            based_near_attributes: [:id, :_destroy],
            member_of_collections_attributes: [:id, :_destroy],
            work_members_attributes: [:id, :_destroy]
          }
        ]
      end
    end

    # override (from Hyrax 2.5.0) - override the initializer:
    #   set the terms and required terms to those from the contextual schema
    def initialize(model, current_ability, controller)
      model.admin_set_id = controller.params['admin_set_id'] if controller&.params&.[]('admin_set_id')&.present?
      self.dynamic_schema_service = model.dynamic_schema_service(update: true)
      self.class.terms = (dynamic_schema_service.property_keys + self.class.base_terms).uniq
      self.class.required_fields = [:profile_version] + dynamic_schema_service.required_properties

      super(model, current_ability, controller)
    end
  end
end
