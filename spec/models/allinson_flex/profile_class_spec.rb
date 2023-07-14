# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinsonFlex::ProfileClass, type: :model do
  let(:profile_class) { FactoryBot.build(:allinson_flex_class) }

  it 'is valid' do
    expect(profile_class).to be_valid
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:display_label) }
  end
  describe 'associations' do
    # @todo fix -- it { should have_and_belongs_to_many(:contexts) }
    it { is_expected.to have_many(:class_texts).class_name('AllinsonFlex::ProfileText') }
    it { is_expected.to have_many(:properties).class_name('AllinsonFlex::ProfileProperty').through(:available_properties) }
  end
end
