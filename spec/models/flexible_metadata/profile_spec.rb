# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FlexibleMetadata::Profile, type: :model do
  let(:profile) { FactoryBot.build(:flexible_metadata_profile, profile_version: 1.0) }

  it 'is valid' do
    expect(profile).to be_valid
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:profile_version) }
    it { is_expected.to validate_presence_of(:responsibility) }
  end
  describe 'associations' do
    it { is_expected.to have_many(:dynamic_schemas).class_name('FlexibleMetadata::DynamicSchema') }
    it { is_expected.to have_many(:flexible_metadata_contexts).class_name('FlexibleMetadata::Context') }
    it { is_expected.to have_many(:classes).class_name('FlexibleMetadata::ProfileClass') }
    it { is_expected.to have_many(:contexts).class_name('FlexibleMetadata::ProfileContext') }
    it { is_expected.to have_many(:properties).class_name('FlexibleMetadata::ProfileProperty') }
  end
  describe 'serializations' do
    it { is_expected.to serialize(:profile) }
  end
  describe 'methods' do
    before do
      profile.add_date_modified
      profile.add_profile_data
    end

    it '#available_classes returns an array of Classes' do
      expect(profile.available_classes).to eq(
        %w[Image BibRecord PagedResource Scientific]
      )
    end
    it '#profile is set' do
      expect(profile.profile).to eq('flexible_metadata_version' => nil,
                                    'profile' => {
                                      'responsibility' => 'http://iu.edu',
                                      'date_modified' => '2019-09-23',
                                      'version' => 1.0
                                    },
                                    'classes' => {
                                      'Image' => {
                                        'display_label' => 'Flexible Work',
                                        'contexts' => ['flexible_context']
                                      }
                                    },
                                    'contexts' => {
                                      'flexible_context' => {
                                        'display_label' => 'Flexible Context'
                                      }
                                    },
                                    'properties' => {
                                      'title' => {
                                        'display_label' => {
                                          'default' => 'Title'
                                        },
                                        'available_on' => {
                                          'class' => ['Image'],
                                          'context' => ['flexible_context']
                                        },
                                        'cardinality' => {
                                          'minimum' => 0,
                                          'maximum' => 100
                                        },
                                        'indexing' => ['stored_searchable'],
                                        'property_uri' => 'http://example.com/properties/title'
                                      }
                                    })
    end
    it '#available_text_names returns an array of values' do
      expect(profile.available_text_names).to eq(
        [['Display Label', 'display_label']]
      )
    end
    it '#date_modified to be set' do
      expect(profile.date_modified).not_to be_empty
    end
  end
end
