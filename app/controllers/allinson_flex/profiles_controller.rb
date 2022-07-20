# frozen_string_literal: true

module AllinsonFlex
  class ProfilesController < ApplicationController
    include Hyrax::ThemedLayoutController
    require 'yaml'

    before_action do
      authorize! :manage, AllinsonFlex::Profile
    end
    before_action :set_allinson_flex_profile, only: [:show, :destroy, :unlock]
    before_action :set_default_schema, only: [:new, :edit]
    with_themed_layout 'dashboard'

    # GET /allinson_flex_profiles
    def index
      add_breadcrumbs
      @profiles = AllinsonFlex::Profile.page(params[:profile_entries_page])
    end

    # GET /allinson_flex_profiles/1
    def show
      add_breadcrumbs
      add_breadcrumb 'Show'
    end

    # GET /allinson_flex_profiles/new
    def new
      redirect_to profiles_path, alert: 'Edit an Existing Profile or Upload a New One' if AllinsonFlex::Profile.any?

      add_breadcrumbs
      add_breadcrumb 'New'
      @allinson_flex_profile = AllinsonFlex::Profile.new

      @allinson_flex_profile.profile_classes.build
      @allinson_flex_profile.profile_contexts.build
      @allinson_flex_profile.properties.build.texts.build
    end

    # GET /allinson_flex_profiles/1/edit
    def edit
      add_breadcrumbs
      add_breadcrumb 'Edit'

      @allinson_flex_profile = AllinsonFlex::Profile.current_version
      # auto update date on save
      @allinson_flex_profile.profile['profile']['date_modified'] = Date.today.strftime('%Y-%m-%d')
      @allinson_flex_profile.update(locked_by_id: current_user.id, locked_at: Time.now)
    end

    # POST /allinson_flex_profiles
    def create
      @allinson_flex_profile = AllinsonFlex::Profile.new(
        name: (allinson_flex_profile_params[:name] || "Profile #{Time.now.utc.iso8601}"),
        profile: allinson_flex_profile_params[:data].to_h
      )

      # if AllinsonFlex::Profile.current_version.profile == allinson_flex_profile_params[:data].to_h

      if @allinson_flex_profile.save
        AllinsonFlex::Importer.load_profile_from_data(profile_id: @allinson_flex_profile.id, data: @allinson_flex_profile.profile)
        redirect_to profiles_path, notice: 'Allinson Flex Profile was successfully created.'
      else
        render :new
      end
    end

    def import
      uploaded_io = params[:file]
      if uploaded_io.blank?
        redirect_to profiles_path, alert: 'Please select a file to upload'
        return
      end

      @allinson_flex_profile = AllinsonFlex::Importer.load_profile_from_path(path: uploaded_io.path)

      if @allinson_flex_profile.save
        redirect_to profiles_path, notice: 'AllinsonFlexProfile was successfully created.'
      else
        redirect_to profiles_path, alert: @allinson_flex_profile.errors.messages.to_s
      end
    end

    def export
      @allinson_flex_profile = AllinsonFlex::Profile.find(params[:profile_id])
      filename = "metadata-profile-v.#{@allinson_flex_profile.profile_version}.yml"
      File.open(filename, "w") { |file| file.write(@allinson_flex_profile.profile.to_hash.to_yaml(indentation: 8)) }
      send_file filename, type: "application/yaml", x_sendfile: true
    end

    # DELETE /allinson_flex_profiles/1
    def destroy
      @allinson_flex_profile.destroy
      message = 'AllinsonFlexProfile was successfully destroyed.'
      message = @allinson_flex_profile.errors[:base] if @allinson_flex_profile.errors[:base]
      redirect_to profiles_path, notice: message
    end

    def unlock
      if @allinson_flex_profile.update(locked_by_id: nil, locked_at: nil)
        redirect_to profiles_path, notice: 'AllinsonFlexProfile was successfully unlocked.'
      else
        redirect_to profiles_path, alert: @allinson_flex_profile.errors.messages.to_s
      end
    end

    private

      def set_default_schema
        File.open(AllinsonFlex.m3_schema_path) do |f|
          @default_schema = JSON.load f
        end
      end

      def add_breadcrumbs
        add_breadcrumb t(:'hyrax.controls.home'), main_app.root_path
        add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
        add_breadcrumb t(:'allinson_flex.dashboard.profiles'), allinson_flex.profiles_path
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_allinson_flex_profile
        @allinson_flex_profile = AllinsonFlex::Profile.find(params[:id])
      end

      def allinson_flex_profile_params
        params.require(:allinson_flex_profile).permit!
      end
  end
end
