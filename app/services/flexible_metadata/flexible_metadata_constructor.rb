module M3
  class FlexibleMetadataConstructor
    class_attribute :default_logger
    self.default_logger = Rails.logger

    def self.find_or_create_from(name:, data:, logger: default_logger)
      profile_name = data.dig('name') || name
      profile_match = M3::Profile.where(name: profile_name, profile_version: data.dig('profile', 'version')).first

      if profile_match.blank?
        profile = M3::Profile.new(
          name:                     profile_name,
          m3_version:               data.dig('m3_version'),
          profile_version:          data.dig('profile', 'version'),
          responsibility:           data.dig('profile', 'responsibility'),
          responsibility_statement: data.dig('profile', 'responsibility_statement'),
          date_modified:            data.dig('profile', 'date_modified'),
          profile_type:             data.dig('profile', 'type'),
          profile:                  data
        )

        construct_profile_contexts(profile: profile)
        profile.save!
        logger.info(%(Loaded M3::Profile "#{profile.name}" ID=#{profile.id}))

        create_dynamic_schemas(profile: profile)

        profile
      else
        if profile_match.profile != data
          logger.error(%(\nM3::Profile version #{profile_match.profile_version} found, but the content has changed))
          raise ProfileVersionError, "This M3::Profile version (#{profile_match.profile_version}) already exists, please increment the version number"
        else
          logger.info(%(Loaded M3::Profile "#{profile_match.name}" ID=#{profile_match.id}))
          profile_match
        end
      end
    end

    def self.create_dynamic_schemas(profile:, logger: default_logger)
      profile = construct_default_dynamic_schemas(profile: profile)
      profile = construct_dynamic_schemas(profile: profile)
      profile.save!
      logger.info(%(Created M3::Context and M3::DynamicSchema objects for "#{profile.name}" ID=#{profile.id}))
    end

    def self.build_profile_data(profile:)
      {
        'm3_version' => profile.m3_version,
        'profile' => {
          'responsibility' => profile.responsibility,
          'responsibility_statement' => profile.responsibility_statement,
          'date_modified' => profile.date_modified,
          'type' => profile.profile_type,
          'version' => profile.profile_version
        }.compact,
        'classes' =>
          profile.classes.map do |cl|
            {
              cl.name.strip => {
                'display_label' => cl.display_label,
                'schema_uri' => cl.schema_uri,
                'contexts' => cl.contexts.map(&:name)
              }.compact
            }
          end.inject(:merge),
        'contexts' =>
          profile.contexts.map do |cxt|
            {
              cxt.name.strip => {
                'display_label' => cxt.display_label
              }.compact
            }
          end.inject(:merge),
        'properties' =>
          profile.properties.map do |prop|
            class_text = prop.texts.map { |text| text if text.name == 'display_label' && text.textable_type == 'M3::ProfileClass' }.compact
            context_text = prop.texts.map { |text| text if text.name == 'display_label' && text.textable_type == 'M3::ProfileContext' }.compact
            display_labels = []
            display_labels << { 'default' => prop.texts.map { |text| text.value if text.name == 'display_label' && text.textable_type.nil? }.compact.first }
            class_text.each do |clt|
              display_labels << { clt.textable.name => clt.value }.compact
            end
            context_text.each do |cxtt|
              display_labels << { cxtt.textable.name => cxtt.value }.compact
            end

            {
              prop.name.strip => {
                'display_label' => display_labels.inject(:merge),
                'property_uri' => build_property_uri(
                  property_name: prop.name, 
                  property_uri: prop.property_uri
                ),
                'available_on' => {
                  'class' => prop.available_on_classes.map(&:name),
                  'context' => prop.available_on_contexts.map(&:name)
                }.compact,
                'cardinality' => {
                  'minimum' => prop.cardinality_minimum,
                  'maximum' => prop.cardinality_maximum
                }.compact,
                'indexing' => prop.indexing
              }.compact
            }
          end.inject(:merge)
      }
    end

    private

    def self.construct_profile_contexts(profile:, logger: default_logger)
      profile_contexts_hash = profile.profile.dig('contexts')

      profile_contexts_hash.keys.each do |name|
        profile_context = profile.contexts.build(
          name:          name,
          display_label: profile_contexts_hash.dig(name, 'display_label')
        )
        logger.info(%(Constructed M3::ProfileContext "#{profile_context.name}"))

        construct_profile_classes(profile: profile, profile_context: profile_context)

        profile_context
      end
    end

    def self.construct_profile_classes(profile:, profile_context:, logger: default_logger)
      profile_classes_hash = profile.profile.dig('classes')

      profile_classes_hash.keys.each do |name|
        profile_class = profile.classes.build(
          name:          name,
          display_label: profile_classes_hash.dig(name, 'display_label'),
          schema_uri:    profile_classes_hash.dig(name, 'schema_uri')
        )
        logger.info(%(Constructed M3::ProfileClass "#{profile_class.name}"))

        profile_class.contexts << profile_context

        construct_profile_properties(profile: profile, profile_context: profile_context, profile_class: profile_class)

        profile_class
      end
    end

    def self.construct_profile_properties(profile:, profile_context:, profile_class:, logger: default_logger)
      properties_hash = profile.profile.dig('properties')

      properties_hash.keys.each do |name|
        property = profile.properties.build(
          name:                name,
          property_uri:        properties_hash.dig(name, 'property_uri'),
          cardinality_minimum: properties_hash.dig(name, 'cardinality', 'minimum'),
          cardinality_maximum: properties_hash.dig(name, 'cardinality', 'maximum'),
          indexing:            properties_hash.dig(name, 'indexing')
        )
        logger.info(%(Constructed M3::ProfileProperty "#{property.name}"))

        context = properties_hash.dig(name, 'available_on', 'context')
        if context.present? && context.include?(profile_context.name)
          property.available_on_contexts << profile_context
        end
        property.available_on_classes << profile_class if properties_hash.dig(name,'available_on', 'class').include?(profile_class.name)

        property_text = property.texts.build(
          name:  'display_label',
          value: properties_hash.dig(name, 'display_label', 'default')
        )

        logger.info(%(Constructed M3::ProfileText "#{property_text.value}" for M3::ProfileProperty "#{property.name}"))

        if properties_hash.dig(name, 'display_label').keys.include? profile_context.name
          property_text = property.texts.build(
            name:  'display_label',
            value: properties_hash.dig(name, 'display_label', profile_context.name),
            textable: profile_context
          )
          logger.info(%(Constructed M3::ProfileText "#{property_text.value}" for M3::ProfileProperty "#{property.name} on #{profile_context.name}"))
        end

        if properties_hash.dig(name, 'display_label').keys.include? profile_class.name
          property_text = property.texts.build(
            name:  'display_label',
            value: properties_hash.dig(name, 'display_label', profile_class.name),
            textable: profile_class
          )
          logger.info(%(Constructed M3::ProfileText "#{property_text.value}" for M3::ProfileProperty "#{property.name}" on #{profile_class.name}))
        end

        property
      end
    end

    def self.construct_default_dynamic_schemas(profile:, logger: default_logger)
      cxt = profile.contexts.build(name: 'default', display_label: 'Default Metadata Context')

      profile.classes.each do |cl|
        profile.dynamic_schemas.build(
            m3_class: cl.name,
            m3_context: profile.m3_contexts.build(
              name: 'default', 
              m3_profile_context: cxt),
            schema: build_schema(cl)
          )
      end
      profile
    end

    def self.construct_dynamic_schemas(profile:, logger: default_logger)
      profile.classes.each do |cl|
        cl.contexts.each do |cl_cxt|
          profile.dynamic_schemas.build(
            m3_class: cl.name,
            m3_context: profile.m3_contexts.build(
              name: cl_cxt.name, 
              m3_profile_context: cl_cxt),
            schema: build_schema(cl, cl_cxt)
          )
        end
      end
      profile
    end

    def self.build_schema(m3_class, m3_context = nil)
      {
        'type' => m3_class.schema_uri || "http://example.com/#{m3_class.name}",
        'display_label' => m3_class.display_label,
        'properties' =>
          (m3_context || m3_class).available_properties.map do |prop|
            property = prop.m3_profile_property
            {
              property.name => {
                'predicate' => property.property_uri,
                'display_label' => display_label(property, m3_class, m3_context),
                'required' => required?(property.cardinality_minimum),
                'singular' => singular?(property.cardinality_maximum),
                'indexing' => property.indexing
              }.compact
            }.compact
          end.inject(:merge)
      }
    end

    def self.required?(cardinality_minimum)
      return false if cardinality_minimum.blank?
      cardinality_minimum > 0
    end

    def self.singular?(cardinality_maximum)
      return false if cardinality_maximum.blank?
      cardinality_maximum > 1
    end

    def self.display_label(property, m3_class, m3_context = nil)
      unless m3_context.nil?
        context_label = m3_context.context_texts.map { |t| t.value if t.name == 'display_label' && t.m3_profile_property_id == property.id }.first
        return context_label unless context_label.blank?
      end
      class_label = m3_class.class_texts.map { |t| t.value if t.name == 'display_label' && t.m3_profile_property_id == property.id }.first
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
