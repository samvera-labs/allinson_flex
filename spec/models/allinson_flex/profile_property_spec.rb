# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinsonFlex::ProfileProperty, type: :model do
  let(:profile_property) { FactoryBot.build(:profile_property) }

  it 'is valid' do
    expect(profile_property).to be_valid
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to allow_value(['stored_searchable']).for(:indexing) }
    it { is_expected.not_to allow_value(['invalid']).for(:indexing) }
  end
  describe 'associations' do
    it { is_expected.to have_many(:available_on_classes).class_name('AllinsonFlex::ProfileClass') }
    it { is_expected.to have_many(:available_on_contexts).class_name('AllinsonFlex::ProfileContext') }
    it { is_expected.to have_many(:texts).class_name('AllinsonFlex::ProfileText') }
  end
  describe 'serializations' do
    it { is_expected.to serialize(:indexing).as(Array) }
  end
end
