# frozen_string_literal: true

module FlexibleMetadata
  module Ability
    extend ActiveSupport::Concern

    included do
      self.ability_logic += [:flexible_metadata_profile_abilities]
    end

    def flexible_metadata_profile_abilities
      can :manage, FlexibleMetadata::Profile if current_user.admin?
    end
  end
end
