
module FlexibleMetadata
  module DynamicSolrDocument
    extend ActiveSupport::Concern

    included do
      # override (from Hyrax 2.5.0) - setup the solr attributes dynamically
      # Gather all properties from the latest profile and setup the attributes
      # The SolrDocument is independent of the Model and Context, hence we use
      # profile directly.
      profile = FlexibleMetadata::Profile.current_version
      profile.properties.each do |prop|
        attribute(
          prop.name,
          # if the property is singular, make it so
          prop.cardinality_maximum == 1 ? Hyrax::SolrDocument::Metadata::Solr::String : Hyrax::SolrDocument::Metadata::Solr::Array,
          solr_name(prop.name.to_s)
        )
      end unless profile.blank?
      attribute :dynamic_schema, Hyrax::SolrDocument::Metadata::Solr::String, solr_name(:dynamic_schema)
    end
  end
end
