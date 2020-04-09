# frozen_string_literal: true

FactoryBot.define do
  factory :flexible_metadata_context, class: FlexibleMetadata::Context do
    name { "flexible_context" }
    flexible_metadata_profile { FactoryBot.build(:flexible_metadata_profile) }
    flexible_metadata_profile_context { FactoryBot.build(:flexible_metadata_profile_context) }
  end

  factory :flexible_metadata_context_assigned, class: FlexibleMetadata::Context do
    name { "flexible_context" }
    flexible_metadata_profile { FactoryBot.build(:flexible_metadata_profile) }
    admin_set_ids { [AdminSet.find_or_create_default_admin_set_id] }
    flexible_metadata_profile_context { FactoryBot.build(:flexible_metadata_profile_context) }
  end

  factory :flexible_metadata_context_default, class: FlexibleMetadata::Context do
    name { "default" }
    flexible_metadata_profile { FactoryBot.build(:flexible_metadata_profile) }
    flexible_metadata_profile_context { FactoryBot.build(:flexible_metadata_profile_context) }
  end
end

# factory assigned flexible_metadata context that doesnt exist on the context model

# associatiosn between context and priofile cntext are not working
