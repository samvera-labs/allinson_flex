# frozen_string_literal: true

module AllinsonFlex
  class ProfileClassContext < ApplicationRecord
    self.table_name = 'allinson_flex_profile_classes_contexts'
    belongs_to :profile_class, required: false
    belongs_to :profile_context, required: false
  end
end
