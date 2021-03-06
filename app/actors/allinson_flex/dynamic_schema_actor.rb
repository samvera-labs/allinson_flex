module AllinsonFlex
  class DynamicSchemaActor < Hyrax::Actors::AbstractActor
    def create(env)
      add_dynamic_schema(env)
      next_actor.create(env)
    end

    def update(env)
      add_dynamic_schema(env)
      next_actor.update(env)
    end

    # @param [Hyrax::Actors::Environment] env
    def add_dynamic_schema(env)
      schema = env.curation_concern.dynamic_schema_service(as_id: env.attributes[:admin_set_id], update: true ).dynamic_schema
      env.curation_concern.dynamic_schema = schema
      env.attributes[:dynamic_schema_id] = schema.id
      env.attributes[:profile_version] = schema.profile_version.to_f
    end
  end
end
