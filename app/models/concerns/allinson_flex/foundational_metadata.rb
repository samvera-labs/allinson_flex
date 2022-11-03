# frozen_string_literal: true

module AllinsonFlex
  # Defines properties from Hyrax's BasicMetadata which can not yet be defined dynamically
  # @todo: test if AllinsonFlex can define these dynamically
  #   if not, document why, and if so, remove
  module FoundationalMetadata
    extend ActiveSupport::Concern

    included do
      # properties which should not override standard definition even if included in the yaml
      class_attribute :attributes_not_defined_dynamically
      self.attributes_not_defined_dynamically = [:based_near, :label]

      # Any terms defined here are in the model but not actually available to the app unless they are
      #   1) included in metadata_profile.yml OR 
      #   2) included in base terms in dynamic_form_behavior

      # unsure how/if this is used - possibly indicates the name to be used when downloading a datastream's contents??
      # Does not work to define in yaml, apparently because of predicate
      property :label, predicate: ActiveFedora::RDF::Fcrepo::Model.downloadFilename, multiple: false

      # For property :based_near -- required by & requires "include Hyrax::IndexesLinkedMetadata"
      property :keyword, predicate: ::RDF::Vocab::SCHEMA.keywords # must be present, but doesn't need to override yaml.
      property :based_near, predicate: ::RDF::Vocab::FOAF.based_near, class_name: Hyrax::ControlledVocabularies::Location

      id_blank = proc { |attributes| attributes[:id].blank? }
      class_attribute :controlled_properties
      self.controlled_properties = [:based_near]
      accepts_nested_attributes_for :based_near, reject_if: id_blank, allow_destroy: true
    end
  end
end