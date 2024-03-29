# frozen_string_literal: true

module AllinsonFlex
  module DynamicSolrDocument
    extend ActiveSupport::Concern

    included do
      attribute :dynamic_schema_id, Hyrax::SolrDocument::Metadata::Solr::String, "dynamic_schema_id_ssi"
      attribute :profile_version, Hyrax::SolrDocument::Metadata::Solr::String, "profile_version_ssi"
    end

    class_methods do
      def load_allinson_flex
        # override (from Hyrax 2.5.0) - setup the solr attributes dynamically
        # Gather all properties from the latest profile and setup the attributes
        # The SolrDocument is independent of the Model and Context, hence we use
        # profile directly.
        profile = AllinsonFlex::Profile.current_version
        unless profile.blank?
          # Loading attributes is done by defining a method for each property. This only needs to be done once or when the profile changes.
          # Code that needs to run for every SolrDocument instance should go outside this block.
          if @loaded_allinson_flex_version != profile.profile_version
            Rails.logger.debug { "AllinsonFlex profile not yet loaded, or version mismatch. Setting attributes..." }
            profile.properties.each do |prop|
              data_type = if prop.try(:multi_value).present?
                            prop.multi_value ? Hyrax::SolrDocument::Metadata::Solr::Array : Hyrax::SolrDocument::Metadata::Solr::String
                          elsif prop.cardinality_maximum == 1
                            Hyrax::SolrDocument::Metadata::Solr::String 
                          else
                            Hyrax::SolrDocument::Metadata::Solr::Array
                          end

              attribute(prop.name, data_type,"#{prop.name.to_s}_tesim")
            end
            @loaded_allinson_flex_version = profile.profile_version
          end
        end
      end
    end

    def initialize(source_doc = {}, response = nil)
      self.class.load_allinson_flex
      super(source_doc, response)
    end
  end
end
