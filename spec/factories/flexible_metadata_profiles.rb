# frozen_string_literal: true

FactoryBot.define do
  factory :flexible_metadata_profile, class: FlexibleMetadata::Profile do
    name { "Indiana University" }
    sequence(:profile_version) { |n| n }
    responsibility { 'http://iu.edu' }
    date_modified { '2019-09-23' }
    classes { [FactoryBot.build(:flexible_metadata_profile_class)] }
    contexts { [FactoryBot.build(:flexible_metadata_profile_context)] }
    properties { [FactoryBot.build(:flexible_metadata_profile_property)] }
  end

  factory :flexible_metadata_profile_class, class: FlexibleMetadata::ProfileClass do
    name            { "Image" }
    display_label   { "Flexible Work" }
    contexts { [FactoryBot.build(:flexible_metadata_profile_context)] }
    class_texts { [FactoryBot.build(:flexible_metadata_profile_text_for_class)] }
  end

  factory :flexible_metadata_profile_context, class: FlexibleMetadata::ProfileContext do
    name            { "flexible_context" }
    display_label   { "Flexible Context" }
    context_texts { [FactoryBot.build(:flexible_metadata_profile_text_for_context)] }
  end

  factory :flexible_metadata_profile_property, class: FlexibleMetadata::ProfileProperty do
    name            { "title" }
    indexing        { ['stored_searchable'] }
    available_on_classes { [FactoryBot.build(:flexible_metadata_profile_class)] }
    available_on_contexts { [FactoryBot.build(:flexible_metadata_profile_context)] }
    texts do
      [
        FactoryBot.build(:flexible_metadata_profile_text),
        FactoryBot.build(:flexible_metadata_profile_text_for_class),
        FactoryBot.build(:flexible_metadata_profile_text_for_context)
      ]
    end
  end

  factory :flexible_metadata_profile_text, class: FlexibleMetadata::ProfileText do
    name { "display_label" }
    value { "Title" }
  end

  factory :flexible_metadata_profile_text_for_class, class: FlexibleMetadata::ProfileText do
    name            { "display_label" }
    value           { "Title in Class" }
  end

  factory :flexible_metadata_profile_text_for_context, class: FlexibleMetadata::ProfileText do
    name            { "display_label" }
    value { "Title in Context" }
  end
end
