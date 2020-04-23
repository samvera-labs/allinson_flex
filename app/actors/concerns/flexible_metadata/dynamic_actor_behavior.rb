# frozen_string_literal: true

module FlexibleMetadata
  module DynamicActorBehavior
    # @param [Hyrax::Actors::Environment] env
    def add_dynamic_schema(env)
      if env.curation_concern.respond_to?(:dynamic_schema)
        env.curation_concern.dynamic_schema = env.curation_concern.base_dynamic_schema(
          env.attributes[:admin_set_id]
        )
      end
    end
  end
end
