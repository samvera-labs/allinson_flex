# frozen_string_literal: true

module AllinsonFlex
  module DynamicCatalogBehavior
    extend ActiveSupport::Concern

    class_methods do
      def load_allinson_flex
        profile = AllinsonFlex::Profile.current_version
        unless profile.blank?
          profile.properties.each do |prop|
            # blacklight wants 1 label for all classes with this property
            # therefor we need to use the default label
            label = prop.texts.map { |t| t.value if t.name == 'display_label' && t.textable_type.nil? }.compact.first
            if prop.indexing.include?("stored_searchable")
              index_args = {
                itemprop: prop.name,
                label: label
              }

              if prop.indexing.include?("admin_only")
                index_args[:if] = lambda { |context, _field_config, _document| context.try(:current_user)&.admin? }
              end

              if prop.indexing.include?("facetable")
                index_args[:link_to_facet] = "#{prop.name.to_s}}_sim"
              end

              name = "#{prop.name.to_s}}_tesim"
              unless blacklight_config.index_fields[name].present?
                blacklight_config.add_index_field(name, index_args)
              end
            end

            if prop.indexing.include?("facetable")
              name = "#{prop.name.to_s}}_sim"
              facet_args = { label: label }
              if prop.indexing.include?("admin_only")
                facet_args[:if] = lambda { |context, _field_config, _document| context.try(:current_user)&.admin? }
              end
              unless blacklight_config.facet_fields[name].present?
                blacklight_config.add_facet_field(name, **facet_args)
              end
            end
          end
        end
      end
    end

    def initialize
      self.class.load_allinson_flex
      super
    end
  end
end
