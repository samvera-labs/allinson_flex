# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinsonFlex::DynamicSchema, type: :model do
  let(:dynamic_schema) { FactoryBot.build(:dynamic_schema) }

  it 'is valid' do
    expect(dynamic_schema).to be_valid
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:allinson_flex_class) }
    it { is_expected.to validate_presence_of(:schema) }
  end
  describe 'associations' do
    it { is_expected.to belong_to(:allinson_flex_context).class_name('AllinsonFlex::Context') }
    it { is_expected.to belong_to(:allinson_flex_profile).class_name('AllinsonFlex::Profile') }
  end
  describe 'serializations' do
    it { is_expected.to serialize(:schema) }
  end
end
