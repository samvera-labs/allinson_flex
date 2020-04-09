require 'rails_helper'

RSpec.describe FlexibleMetadata::ProfileClass, type: :model do
  let(:profile_class) { FactoryBot.build(:flexible_metadata_profile_class) }

  it 'is valid' do
    expect(profile_class).to be_valid
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:display_label) }
  end
  describe 'associations' do
    # @todo fix -- it { should have_and_belongs_to_many(:contexts) }
    it { should have_many(:class_texts).class_name('FlexibleMetadata::ProfileText') }
    it { should have_many(:properties).class_name('FlexibleMetadata::ProfileProperty').through(:available_properties) }
  end
end
