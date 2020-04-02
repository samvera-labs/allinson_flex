module Hyrax
  module Dashboard
    ## Shows a list of all m3_profiles to the admins
    class M3ProfilesController < Hyrax::My::M3ProfilesController
      # Search builder for a list of m3_profiles
      # Override of Blacklight::RequestBuilders
    end
  end
end
