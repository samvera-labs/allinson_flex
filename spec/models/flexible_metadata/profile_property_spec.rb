require 'rails_helper'

RSpec.describe FlexibleMetadata::ProfileProperty, type: :model do
  let(:profile_property) { FactoryBot.build(:flexible_metadata_profile_property) }

  it 'is valid' do
    expect(profile_property).to be_valid
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should allow_value(['stored_searchable']).for(:indexing) }
    it { should_not allow_value(['invalid']).for(:indexing) }
  end
  describe 'associations' do
    it { should have_many(:available_on_classes).class_name('FlexibleMetadata::ProfileClass') }
    it { should have_many(:available_on_contexts).class_name('FlexibleMetadata::ProfileContext') }
    it { should have_many(:texts).class_name('FlexibleMetadata::ProfileText') }
  end
  describe 'serializations' do
    it { should serialize(:indexing).as(Array) }
  end
end
