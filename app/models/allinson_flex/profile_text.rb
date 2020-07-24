# frozen_string_literal: true

module AllinsonFlex
  class ProfileText < ApplicationRecord
    belongs_to :textable, polymorphic: true, required: false

    validates :name, :value, presence: true
  end
end
