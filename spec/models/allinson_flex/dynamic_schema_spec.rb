# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinsonFlex::DynamicSchema, type: :model do
  let(:dynamic_schema) { FactoryBot.build(:dynamic_schema) }

  it 'is valid' do
    expect(dynamic_schema).to be_valid
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:flexible_metadata_class) }
    it { is_expected.to validate_presence_of(:schema) }
  end
  describe 'associations' do
    it { is_expected.to belong_to(:flexible_metadata_context).class_name('FlexibleMetadata::Context') }
    it { is_expected.to belong_to(:flexible_metadata_profile).class_name('FlexibleMetadata::Profile') }
  end
  describe 'serializations' do
    it { is_expected.to serialize(:schema) }
  end
end
