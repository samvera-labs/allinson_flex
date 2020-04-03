require 'rails_helper'

RSpec.describe FlexibleMetadata::ProfileText, type: :model do
  let(:profile_text) { FactoryBot.build(:flexible_metadata_profile_text) }

  it 'is valid' do
    expect(profile_text).to be_valid
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:value) }
  end
  describe 'associations' do
    it { should belong_to(:textable).optional }
  end
end
