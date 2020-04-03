require 'rails_helper'

RSpec.describe FlexibleMetadata::Importer do
  describe '#load_profile_from_path' do
    let(:profile) { FlexibleMetadata::Importer.load_profile_from_path(path: File.join(RSpec.configuration.fixture_path, 'files/yaml_example.yaml')) }

    it 'returns valid with a valid path' do
      expect(profile)
        .to be_valid
    end

    it 'returns valid without a specified path' do
      expect(FlexibleMetadata::Importer.load_profile_from_path)
        .to be_valid
    end

    it 'raises an error with an invalid file' do
      expect { FlexibleMetadata::Importer.load_profile_from_path(path: 'app/models/flexible_metadata/profile.rb') }
        .to raise_error(FlexibleMetadata::Importer::YamlSyntaxError)
    end

    it 'uses default config file when path is not a file' do
      expect(profile)
        .to be_an_instance_of(FlexibleMetadata::Profile)
    end

    it 'returns an FlexibleMetadata::Profile instance' do
      expect(profile)
        .to be_an_instance_of(FlexibleMetadata::Profile)
    end

    it 'creates associated dynamic_schema objects, including defualt' do
      expect(profile.dynamic_schemas.count)
        .to eq(2)
    end

    it 'creates associated flexible_metadata_context objects, including default' do
      expect(profile.flexible_metadata_contexts.count)
        .to eq(2)
    end
  end

  describe 'class attributes' do
    it '#default_logger' do
      FlexibleMetadata::Importer.default_logger == Rails.logger
    end

    it '#default_config_file' do
      path_to_file = FlexibleMetadata::Importer.default_config_file
      expect(path_to_file).to include('config/metadata_profiles/')
    end
  end
end
