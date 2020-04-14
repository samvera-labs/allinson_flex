# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FlexibleMetadata::ProfileContext, type: :model do
  let(:profile_context) { FactoryBot.build(:flexible_metadata_profile_context) }

  it 'is valid' do
    expect(profile_context).to be_valid
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:display_label) }
  end
  describe 'associations' do
    it { is_expected.to have_many(:context_texts).class_name('FlexibleMetadata::ProfileText') }
    it { is_expected.to have_many(:properties).class_name('FlexibleMetadata::ProfileProperty').through(:available_properties) }
  end
end
