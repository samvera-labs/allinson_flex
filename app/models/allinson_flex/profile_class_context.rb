# frozen_string_literal: true

module AllinsonFlex
  class ProfileClassContext < ApplicationRecord
    belongs_to :profile_class, required: false
    belongs_to :profile_context, required: false
  end
end
