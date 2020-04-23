# frozen_string_literal: true

module FlexibleMetadata
  class ProfilesController < ApplicationController
    include Hyrax::ThemedLayoutController
    require 'yaml'

    before_action do
      authorize! :manage, FlexibleMetadata::Profile
    end
    before_action :set_flexible_metadata_profile, only: [:show, :destroy]
    before_action :set_default_schema, only: [:new, :edit]
    with_themed_layout 'dashboard'

    # GET /flexible_metadata_profiles
    def index
      add_breadcrumbs
      @flexible_metadata_profiles = FlexibleMetadata::Profile.all
    end

    # GET /flexible_metadata_profiles/1
    def show
      add_breadcrumbs
      add_breadcrumb 'Show'
    end

    # GET /flexible_metadata_profiles/new
    def new
      redirect_to profiles_path, alert: 'Edit an Existing Profile or Upload a New One' if FlexibleMetadata::Profile.any?

      add_breadcrumbs
      add_breadcrumb 'New'
      @flexible_metadata_profile = FlexibleMetadata::Profile.new

      @flexible_metadata_profile.classes.build
      @flexible_metadata_profile.contexts.build
      @flexible_metadata_profile.properties.build.texts.build
    end

    # GET /flexible_metadata_profiles/1/edit
    def edit
      add_breadcrumbs
      add_breadcrumb 'Edit'

      @flexible_metadata_profile = FlexibleMetadata::Profile.current_version
    end

    # POST /flexible_metadata_profiles
    def create
      @flexible_metadata_profile = FlexibleMetadata::Profile.new(
        name: (flexible_metadata_profile_params[:name] || "Profile #{Time.now.utc.iso8601}"),
        profile: flexible_metadata_profile_params[:data].to_h
      )

      # if FlexibleMetadata::Profile.current_version.profile == flexible_metadata_profile_params[:data].to_h

      if @flexible_metadata_profile.save
        FlexibleMetadata::Importer.load_profile_from_data(profile_id: @flexible_metadata_profile.id, data: @flexible_metadata_profile.profile)
        redirect_to profiles_path, notice: 'Flexible Metadata Profile was successfully created.'
      else
        render :new
      end
    end

    def import
      uploaded_io = params[:file]
      @flexible_metadata_profile = FlexibleMetadata::Importer.load_profile_from_path(path: uploaded_io.path)

      if @flexible_metadata_profile.save
        redirect_to profiles_path, notice: 'FlexibleMetadataProfile was successfully created.'
      else
        redirect_to profiles_path, alert: @flexible_metadata_profile.errors.messages.to_s
      end
    end

    def export
      @flexible_metadata_profile = FlexibleMetadata::Profile.find(params[:profile_id])
      filename = "#{@flexible_metadata_profile.name}-v.#{@flexible_metadata_profile.profile_version}.yml"
      File.open(filename, "w") { |file| file.write(@flexible_metadata_profile.profile.to_hash.to_yaml(indentation: 8)) }
      send_file filename, type: "application/yaml", x_sendfile: true
    end

    # DELETE /flexible_metadata_profiles/1
    def destroy
      @flexible_metadata_profile.destroy
      message = 'FlexibleMetadataProfile was successfully destroyed.'
      message = @flexible_metadata_profile.errors[:base] if @flexible_metadata_profile.errors[:base]
      redirect_to profiles_path, notice: message
    end

    private

      def set_default_schema
        # File.open FlexibleMetadata.m3_schema_path
        new_json_schema = File.open "config/m3_json_schemas/default_schema.json"
        @default_schema = JSON.load new_json_schema
        new_json_schema.close
      end

      def add_breadcrumbs
        add_breadcrumb t(:'hyrax.controls.home'), main_app.root_path
        add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
        add_breadcrumb t(:'flexible_metadata.dashboard.profiles'), flexible_metadata.profiles_path
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_flexible_metadata_profile
        @flexible_metadata_profile = FlexibleMetadata::Profile.find(params[:id])
      end

      def flexible_metadata_profile_params
        params.require(:flexible_metadata_profile).permit!
      end
  end
end
