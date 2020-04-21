module FlexibleMetadata
	module DynamicSchemaActorBehavior
		# @param [Hyrax::Actors::Environment] env
		def add_dynamic_schema(env)
			env.curation_concern.dynamic_schema = env.curation_concern.base_dynamic_schema(
				env.attributes[:admin_set_id]
			)
	end
end