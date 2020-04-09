require 'rails_helper'

RSpec.describe 'hyrax/my/flexible_metadata_profiles/index.html.erb', type: :view do
  before do
    allow(view).to receive(:current_ability).and_return(ability)
    allow(view).to receive(:provide).and_yield
    allow(view).to receive(:provide).with(:page_title, String)
    allow(view).to receive(:can?).and_return(true)
    render
  end

  context "when the user can add flexible_metadata profiles" do
    let(:ability) { instance_double(Ability, flexible_metadata_profile_abilities: true) }

    it 'the line item displays the work and its actions' do
      expect(rendered).to have_selector('h1', text: 'FlexibleMetadata Profiles')
      expect(rendered).to have_link('Create Profile')
    end
  end
end
