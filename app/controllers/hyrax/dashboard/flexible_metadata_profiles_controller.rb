# frozen_string_literal: true

module Hyrax
  module Dashboard
    ## Shows a list of all m3_profiles to the admins
    class FlexibleMetadataProfilesController < Hyrax::My::FlexibleMetadataProfilesController
      # Search builder for a list of m3_profiles
      # Override of Blacklight::RequestBuilders
    end
  end
end
