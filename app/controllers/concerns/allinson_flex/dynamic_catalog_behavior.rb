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

              if prop.indexing.include?("facetable")
                index_args[:link_to_search] = solr_name(prop.name.to_s, :facetable)
              end

              name = solr_name(prop.name.to_s, :stored_searchable)
              unless blacklight_config.index_fields[name].present?
                blacklight_config.add_index_field(name, index_args)
              end
            end

            if prop.indexing.include?("facetable")
              name = solr_name(prop.name.to_s, :facetable)
              unless blacklight_config.facet_fields[name].present?
                blacklight_config.add_facet_field(name, label: label)
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
