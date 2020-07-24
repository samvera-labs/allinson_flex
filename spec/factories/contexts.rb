FactoryBot.define do
  factory :allinson_flex_context, class: AllinsonFlex::Context do
    name       { "flexible_context" }
    allinson_flex_profile { FactoryBot.build(:allinson_flex) }
    allinson_flex_context { FactoryBot.build(:allinson_flex_context) }
  end

  factory :allinson_flex_context_assigned, class: AllinsonFlex::Context do
    name       { "flexible_context" }
    allinson_flex_profile { FactoryBot.build(:allinson_flex) }
    admin_set_ids { [AdminSet.find_or_create_default_admin_set_id] }
    allinson_flex_context { FactoryBot.build(:allinson_flex_context) }
  end

  factory :allinson_flex_context_default, class: AllinsonFlex::Context do
    name       { "default" }
    allinson_flex_profile { FactoryBot.build(:allinson_flex) }
    allinson_flex_context { FactoryBot.build(:allinson_flex_context) }
  end
end
