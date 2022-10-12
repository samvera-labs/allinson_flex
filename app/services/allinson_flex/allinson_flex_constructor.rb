# frozen_string_literal: true

module AllinsonFlex
  class AllinsonFlexConstructor
    class_attribute :default_logger
    self.default_logger = Rails.logger

    def self.find_or_create_from(profile_id:, data:, logger: default_logger)
      profile = AllinsonFlex::Profile.find(profile_id) unless profile_id.nil?

      # when loading from path, we need to create the profile
      # when loading from form data, we already have the profile
      if profile.blank?
        profile = AllinsonFlex::Profile.new(
          profile: data,
          profile_version: data.dig('profile', 'version'),
          m3_version: data.dig('m3_version')
        )
      end
      profile.responsibility = data.dig('profile', 'responsibility')
      profile.responsibility_statement = data.dig('profile', 'responsibility_statement')
      profile.date_modified = data.dig('profile', 'date_modified')
      profile.profile_type = data.dig('profile', 'type')

      construct_profile_contexts(profile: profile)
      profile.save!
      logger.info(%(LoadedAllinsonFlex::Profile ID=#{profile.id}))
      create_dynamic_schemas(profile: profile)
      profile
    end

    def self.create_dynamic_schemas(profile:, logger: default_logger)
      profile = construct_default_dynamic_schemas(profile: profile)
      profile = construct_dynamic_schemas(profile: profile)
      profile.save!
      logger.info(%(Created AllinsonFlex::Context and AllinsonFlex::DynamicSchema objects for ID=#{profile.id}))
    end

    private

      def self.construct_profile_contexts(profile:, logger: default_logger)
        profile_contexts_hash = profile.profile.dig('contexts')

        profile_contexts_hash.keys.each do |name|
          profile_context = profile.profile_contexts.build(
            name: name,
            display_label: profile_contexts_hash.dig(name, 'display_label')
          )
          logger.info(%(Constructed AllinsonFlex::ProfileContext "#{profile_context.name}"))

          construct_profile_classes(profile: profile, profile_context: profile_context)

          profile_context
        end
      end

      def self.construct_profile_classes(profile:, profile_context:, logger: default_logger)
        profile_classes_hash = profile.profile.dig('classes')

        profile_classes_hash.keys.each do |name|
          profile_class = profile.profile_classes.build(
            name: name,
            display_label: profile_classes_hash.dig(name, 'display_label'),
            schema_uri: profile_classes_hash.dig(name, 'schema_uri')
          )
          logger.info(%(Constructed AllinsonFlex::ProfileClass "#{profile_class.name}"))

          profile_class.profile_contexts << profile_context

          construct_profile_properties(profile: profile, profile_context: profile_context, profile_class: profile_class)

          profile_class
        end
      end

      def self.construct_profile_properties(profile:, profile_context:, profile_class:, logger: default_logger)
        properties_hash = profile.profile.dig('properties')

        properties_hash.keys.each do |name|
          property = profile.properties.build(
            name: name,
            property_uri: properties_hash.dig(name, 'property_uri'),
            cardinality_minimum: properties_hash.dig(name, 'cardinality', 'minimum'),
            cardinality_maximum: properties_hash.dig(name, 'cardinality', 'maximum'),
            indexing: properties_hash.dig(name, 'indexing'),
            multi_value: properties_hash.dig(name, 'multi_value'),
            requirement: properties_hash.dig(name, 'requirement')
          )
          logger.info(%(Constructed AllinsonFlex::ProfileProperty "#{property.name}"))

          context = properties_hash.dig(name, 'available_on', 'context')
          # TODO ALL goes here?
          property.available_on_contexts << profile_context if context.blank? || context.include?(profile_context.name)

          classes = properties_hash.dig(name, 'available_on', 'class')
          property.available_on_classes << profile_class if classes.blank? || classes.include?(profile_class.name)

          property_text = property.texts.build(
            name: 'display_label',
            value: properties_hash.dig(name, 'display_label', 'default')
          )

          logger.info(%(Constructed AllinsonFlex::ProfileText "#{property_text.value}" for AllinsonFlex::ProfileProperty "#{property.name}"))

          if properties_hash.dig(name, 'display_label').keys.include? profile_context.name
            property_text = property.texts.build(
              name: 'display_label',
              value: properties_hash.dig(name, 'display_label', profile_context.name),
              textable: profile_context
            )
            logger.info(%(Constructed AllinsonFlex::ProfileText "#{property_text.value}" for AllinsonFlex::ProfileProperty "#{property.name} on #{profile_context.name}"))
          end

          if properties_hash.dig(name, 'display_label').keys.include? profile_class.name
            property_text = property.texts.build(
              name: 'display_label',
              value: properties_hash.dig(name, 'display_label', profile_class.name),
              textable: profile_class
            )
            logger.info(%(Constructed AllinsonFlex::ProfileText "#{property_text.value}" for AllinsonFlex::ProfileProperty "#{property.name}" on #{profile_class.name}))
          end

          property
        end
      end

      def self.construct_default_dynamic_schemas(profile:, logger: default_logger)

        cxt = AllinsonFlex::ProfileContext.where(
          name: 'default',
          display_label: "Allinson Flex Example",
          profile_id: profile.id
        ).first_or_create

        fm_cxt = AllinsonFlex::Context.where(
          name: 'default',
          profile_context: cxt,
          profile_id: profile.id
        ).first_or_create

        profile.profile_classes.each do |cl|
          profile.dynamic_schemas.build(
            allinson_flex_class: cl.name,
            context: fm_cxt,
            schema: build_schema(cl)
          )
        end
        profile
      end

      def self.construct_dynamic_schemas(profile:, logger: default_logger)
        profile.profile_classes.each do |cl|
          cl.profile_contexts.each do |cl_cxt|
            fm_cxt = AllinsonFlex::Context.where(
              name: cl_cxt.name,
              profile_context: cl_cxt,
              profile_id: profile.id
            ).first_or_create

            profile.dynamic_schemas.build(
              allinson_flex_class: cl.name,
              context: fm_cxt,
              schema: build_schema(cl, cl_cxt)
            )
          end
        end
        profile
      end

      def self.intersection_properties(klass, context = nil)
        if klass && context
          context.available_properties.includes(profile_property: :texts).map(&:profile_property) &
          klass.available_properties.includes(profile_property: :texts).map(&:profile_property)
        else
          klass.available_properties.includes(profile_property: :texts).map(&:profile_property)
        end
      end

      def self.build_schema(klass, context = nil)
        {
          'type' => klass.schema_uri || "http://example.com/#{klass.name}",
          'display_label' => klass.display_label,
          'properties' =>
            intersection_properties(klass, context).map do |property|
              {
                property.name => {
                  'predicate' => property.property_uri,
                  'display_label' => display_label(property, klass, context),
                  'required' => required?(property.try(:requirement), property.cardinality_minimum),
                  'singular' => singular?(property.try(:multi_value), property.cardinality_maximum),
                  'indexing' => property.indexing
                }.compact
              }.compact
            end.inject(:merge)
        }
      end

      def self.required?(requirement, cardinality_minimum)
        return true if requirement == 'required' || cardinality_minimum > 0
        false
      end

      def self.singular?(multi_value, cardinality_maximum)
        return false if multi_value == true || cardinality_maximum.blank? || cardinality_maximum > 1
        return true if cardinality_maximum == 1
      end

      def self.display_label(property, klass, context = nil)
        if context.present?
          context_label = context.context_texts.detect { |t| t.value if t.name == 'display_label' && t.profile_property_id == property.id }&.value
          return context_label unless context_label.blank?
        end
        class_label = klass.class_texts.detect { |t| t.value if t.name == 'display_label' && t.profile_property_id == property.id }&.value
        return class_label unless class_label.blank?
        property.texts.map { |t| t.value if t.name == 'display_label' && t.textable_type.nil? }.compact.first
      end

      def self.build_property_uri(property_name:, property_uri:)
        if property_uri.blank?
          "http://example.com/properties/#{property_name}"
        else
          property_uri
        end
      end

      class ProfileVersionError < StandardError; end
  end
end
