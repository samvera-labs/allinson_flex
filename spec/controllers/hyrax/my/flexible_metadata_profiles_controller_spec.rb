require 'rails_helper'

RSpec.describe Hyrax::My::FlexibleMetadataProfilesController, type: :controller do
  routes { Hyrax::Engine.routes }

  context "when user is unauthenticated" do
    describe "GET #index" do
      it "redirects to sign-in page" do
        get :index
        expect(response).to be_redirect
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end
  end

  context "when logged in as an admin user" do
    let(:user) { create(:user, :admin) }
    let!(:flexible_metadata_profile) { create(:flexible_metadata_profile) }
    let(:valid_session) { {} }

    before { sign_in user }

    describe 'GET #index' do
      it 'returns a success response' do
        expect(controller).to receive(:add_breadcrumb).with('Home', root_path(locale: 'en'))
        expect(controller).to receive(:add_breadcrumb).with('Dashboard', dashboard_path(locale: 'en'))
        expect(controller).to receive(:add_breadcrumb).with('Flexible Metadata Profiles', my_flexible_metadata_profiles_path(locale: 'en'))
        get :index, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end
  end
end
