# frozen_string_literal: true

module AllinsonFlex
  module Ability
    extend ActiveSupport::Concern

    included do
      self.ability_logic += [:flexible_metadata_profile_abilities]
    end

    def flexible_metadata_profile_abilities
      can :manage, AllinsonFlex::Profile if admin?
    end
  end
end
