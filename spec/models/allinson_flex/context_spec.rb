# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinsonFlex::Context, type: :model do
  let(:context) { FactoryBot.build(:allinson_flex_context) }

  it 'is valid' do
    expect(context).to be_valid
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
  describe 'associations' do
    it { is_expected.to have_many(:dynamic_schemas).class_name('AllinsonFlex::DynamicSchema') }
    it { is_expected.to belong_to(:allinson_flex_profile).class_name('AllinsonFlex::Profile') }
  end
  describe 'serializations' do
    it { is_expected.to serialize(:admin_set_ids).as(Array) }
  end
end
