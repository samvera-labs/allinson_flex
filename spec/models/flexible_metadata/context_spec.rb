require 'rails_helper'

RSpec.describe FlexibleMetadata::Context, type: :model do
  let(:context) { FactoryBot.build(:flexible_metadata_context) }

  it 'is valid' do
    expect(context).to be_valid
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
  describe 'associations' do
    it { should have_many(:dynamic_schemas).class_name('FlexibleMetadata::DynamicSchema') }
    it { should belong_to(:flexible_metadata_profile).class_name('FlexibleMetadata::Profile') }
  end
  describe 'serializations' do
    it { should serialize(:admin_set_ids).as(Array) }
  end
end
