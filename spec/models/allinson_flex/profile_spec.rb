# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinsonFlex::Profile, type: :model do
  let(:profile) { FactoryBot.build(:allinson_flex_profile, profile_version: 1.0) }

  it 'is valid' do
    expect(profile).to be_valid
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:profile_version) }
    it { is_expected.to validate_presence_of(:responsibility) }
  end
  describe 'associations' do
    it { is_expected.to have_many(:dynamic_schemas).class_name('AllinsonFlex::DynamicSchema') }
    it { is_expected.to have_many(:contexts).class_name('AllinsonFlex::Context') }
    it { is_expected.to have_many(:profile_classes).class_name('AllinsonFlex::ProfileClass') }
    it { is_expected.to have_many(:profile_contexts).class_name('AllinsonFlex::ProfileContext') }
    it { is_expected.to have_many(:properties).class_name('AllinsonFlex::ProfileProperty') }
  end
  describe 'serializations' do
    it { is_expected.to serialize(:profile) }
  end
  describe 'methods' do
    before do
      profile.add_date_modified
    end

    it '#available_classes returns an array of Classes' do
      expect(profile.available_classes).to eq(
        %w[Image BibRecord PagedResource Scientific]
      )
    end
    it '#profile is set' do
      expect(profile.profile).to be_present
      expect(profile.name).to eq('Indiana University')
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
