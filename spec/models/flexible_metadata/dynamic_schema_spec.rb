require 'rails_helper'

RSpec.describe FlexibleMetadata::DynamicSchema, type: :model do
  let(:dynamic_schema) { FactoryBot.build(:dynamic_schema) }

  it 'is valid' do
    expect(dynamic_schema).to be_valid
  end
  describe 'validations' do
    it { should validate_presence_of(:flexible_metadata_class) }
    it { should validate_presence_of(:schema) }
  end
  describe 'associations' do
    it { should belong_to(:flexible_metadata_context).class_name('FlexibleMetadata::Context') }
    it { should belong_to(:flexible_metadata_profile).class_name('FlexibleMetadata::Profile') }
  end
  describe 'serializations' do
    it { should serialize(:schema) }
  end
end
