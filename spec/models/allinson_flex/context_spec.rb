# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinsonFlex::Context, type: :model do
  let(:context) { FactoryBot.build(:flexible_metadata_context) }

  it 'is valid' do
    expect(context).to be_valid
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
  describe 'associations' do
    it { is_expected.to have_many(:dynamic_schemas).class_name('FlexibleMetadata::DynamicSchema') }
    it { is_expected.to belong_to(:flexible_metadata_profile).class_name('FlexibleMetadata::Profile') }
  end
  describe 'serializations' do
    it { is_expected.to serialize(:admin_set_ids).as(Array) }
  end
end
