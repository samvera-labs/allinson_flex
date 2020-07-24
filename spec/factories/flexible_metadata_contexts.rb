FactoryBot.define do
  factory :flexible_metadata_context, class: FlexibleMetadata::Context do
    name       { "flexible_context" }
    flexible_metadata_profile { FactoryBot.build(:flexible_metadata) }
    flexible_metadata_context { FactoryBot.build(:flexible_metadata_context) }
  end

  factory :flexible_metadata_context_assigned, class: FlexibleMetadata::Context do
    name       { "flexible_context" }
    flexible_metadata_profile { FactoryBot.build(:flexible_metadata) }
    admin_set_ids { [AdminSet.find_or_create_default_admin_set_id] }
    flexible_metadata_context { FactoryBot.build(:flexible_metadata_context) }
  end

  factory :flexible_metadata_context_default, class: FlexibleMetadata::Context do
    name       { "default" }
    flexible_metadata_profile { FactoryBot.build(:flexible_metadata) }
    flexible_metadata_context { FactoryBot.build(:flexible_metadata_context) }
  end
end
