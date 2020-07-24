# frozen_string_literal: true

module AllinsonFlex
  class ProfileClassContext < ApplicationRecord
    belongs_to :allinson_flex_profile_class, required: false, class_name: 'AllinsonFlex::ProfileClass'
    belongs_to :allinson_flex_profile_context, required: false, class_name: 'AllinsonFlex::ProfileContext'
  end
end
