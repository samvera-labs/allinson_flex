# frozen_string_literal: true

FactoryBot.define do
  factory :allinson_flex_profile, class: AllinsonFlex::Profile do
    name { "Indiana University" }
    sequence(:profile_version) { |n| n }
    responsibility { 'http://iu.edu' }
    date_modified { '2019-09-23' }
    classes { [FactoryBot.build(:allinson_flex_class)] }
    contexts { [FactoryBot.build(:allinson_flex_context)] }
    properties { [FactoryBot.build(:allinson_flex_property)] }
  end

  factory :allinson_flex_class, class: AllinsonFlex::ProfileClass do
    name            { "Image" }
    display_label   { "Flexible Work" }
    contexts { [FactoryBot.build(:allinson_flex_context)] }
    class_texts { [FactoryBot.build(:allinson_flex_text_for_class)] }
  end

  factory :allinson_flex_context, class: AllinsonFlex::ProfileContext do
    name            { "flexible_context" }
    display_label   { "Flexible Context" }
    context_texts { [FactoryBot.build(:allinson_flex_text_for_context)] }
  end

  factory :allinson_flex_property, class: AllinsonFlex::ProfileProperty do
    name            { "title" }
    indexing        { ['stored_searchable'] }
    available_on_classes { [FactoryBot.build(:allinson_flex_class)] }
    available_on_contexts { [FactoryBot.build(:allinson_flex_context)] }
    texts do
      [
        FactoryBot.build(:allinson_flex_text),
        FactoryBot.build(:allinson_flex_text_for_class),
        FactoryBot.build(:allinson_flex_text_for_context)
      ]
    end
  end

  factory :allinson_flex_text, class: AllinsonFlex::ProfileText do
    name { "display_label" }
    value { "Title" }
  end

  factory :allinson_flex_text_for_class, class: AllinsonFlex::ProfileText do
    name            { "display_label" }
    value           { "Title in Class" }
  end

  factory :allinson_flex_text_for_context, class: AllinsonFlex::ProfileText do
    name            { "display_label" }
    value { "Title in Context" }
  end
end
