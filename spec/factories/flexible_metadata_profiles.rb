# frozen_string_literal: true

FactoryBot.define do
  factory :flexible_metadata_profile, class: AllinsonFlex::Profile do
    name { "Indiana University" }
    sequence(:profile_version) { |n| n }
    responsibility { 'http://iu.edu' }
    date_modified { '2019-09-23' }
    classes { [FactoryBot.build(:flexible_metadata_class)] }
    contexts { [FactoryBot.build(:flexible_metadata_context)] }
    properties { [FactoryBot.build(:flexible_metadata_property)] }
  end

  factory :flexible_metadata_class, class: AllinsonFlex::ProfileClass do
    name            { "Image" }
    display_label   { "Flexible Work" }
    contexts { [FactoryBot.build(:flexible_metadata_context)] }
    class_texts { [FactoryBot.build(:flexible_metadata_text_for_class)] }
  end

  factory :flexible_metadata_context, class: AllinsonFlex::ProfileContext do
    name            { "flexible_context" }
    display_label   { "Flexible Context" }
    context_texts { [FactoryBot.build(:flexible_metadata_text_for_context)] }
  end

  factory :flexible_metadata_property, class: AllinsonFlex::ProfileProperty do
    name            { "title" }
    indexing        { ['stored_searchable'] }
    available_on_classes { [FactoryBot.build(:flexible_metadata_class)] }
    available_on_contexts { [FactoryBot.build(:flexible_metadata_context)] }
    texts do
      [
        FactoryBot.build(:flexible_metadata_text),
        FactoryBot.build(:flexible_metadata_text_for_class),
        FactoryBot.build(:flexible_metadata_text_for_context)
      ]
    end
  end

  factory :flexible_metadata_text, class: AllinsonFlex::ProfileText do
    name { "display_label" }
    value { "Title" }
  end

  factory :flexible_metadata_text_for_class, class: AllinsonFlex::ProfileText do
    name            { "display_label" }
    value           { "Title in Class" }
  end

  factory :flexible_metadata_text_for_context, class: AllinsonFlex::ProfileText do
    name            { "display_label" }
    value { "Title in Context" }
  end
end
