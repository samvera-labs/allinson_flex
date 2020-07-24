# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinsonFlex::ProfileContext, type: :model do
  let(:profile_context) { FactoryBot.build(:allinson_flex_profile_context) }

  it 'is valid' do
    expect(profile_context).to be_valid
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:display_label) }
  end
  describe 'associations' do
    it { is_expected.to have_many(:context_texts).class_name('AllinsonFlex::ProfileText') }
    it { is_expected.to have_many(:properties).class_name('AllinsonFlex::ProfileProperty').through(:available_properties) }
  end
end
