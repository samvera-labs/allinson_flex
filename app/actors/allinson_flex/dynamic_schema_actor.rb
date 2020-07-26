module AllinsonFlex
  class DynamicSchemaActor < Hyrax::AbstractActor
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
      env.curation_concern.dynamic_schema_id = env.curation_concern.base_dynamic_schema(
        as_id: env.attributes[:admin_set_id] || AdminSet::DEFAULT_ID,
        update: true
      ).id
    end
  end
end
