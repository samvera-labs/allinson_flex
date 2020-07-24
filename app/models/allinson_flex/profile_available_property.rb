# frozen_string_literal: true

module AllinsonFlex
  class ProfileAvailableProperty < ApplicationRecord
    belongs_to :allinson_flex_profile_property, class_name: 'AllinsonFlex::ProfileProperty', required: false
    belongs_to :available_on, polymorphic: true, required: false
  end
end
