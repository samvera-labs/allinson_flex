# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinsonFlex::ProfilesController, type: :controller do
  routes { AllinsonFlex::Engine.routes }

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
    let(:user) { create(:user) }
    let!(:allinson_flex_profile) { create(:allinson_flex_profile) }
    let(:valid_session) { {} }

    before { sign_in user }

    describe 'GET #index' do
      it 'returns a success response' do
        expect(controller).to receive(:add_breadcrumb).with('Home', root_path(locale: 'en'))
        expect(controller).to receive(:add_breadcrumb).with('Dashboard', dashboard_path(locale: 'en'))
        expect(controller).to receive(:add_breadcrumb).with('Allinson Flex Profiles', profiles_path(locale: 'en'))
        get :index, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end
  end
end
