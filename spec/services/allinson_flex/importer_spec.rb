# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AllinsonFlex::Importer do
  describe '#load_profile_from_path' do
    let(:profile) { described_class.load_profile_from_path(path: File.join(RSpec.configuration.fixture_path, 'files/yaml_example.yaml')) }

    it 'returns valid with a valid path' do
      expect(profile)
        .to be_valid
    end

    it 'returns valid without a specified path' do
      expect(described_class.load_profile_from_path)
        .to be_valid
    end

    it 'raises an error with an invalid file' do
      expect { described_class.load_profile_from_path(path: 'app/models/allinson_flex/profile.rb') }
        .to raise_error(AllinsonFlex::Importer::YamlSyntaxError)
    end

    it 'uses default config file when path is not a file' do
      expect(profile)
        .to be_an_instance_of(AllinsonFlex::Profile)
    end

    it 'returns an AllinsonFlex::Profile instance' do
      expect(profile)
        .to be_an_instance_of(AllinsonFlex::Profile)
    end

    it 'creates associated dynamic_schema objects, including defualt' do
      expect(profile.dynamic_schemas.count)
        .to eq(2)
    end

    it 'creates associated allinson_flex_context objects, including default' do
      expect(profile.allinson_flex_contexts.count)
        .to eq(2)
    end
  end

  describe 'class attributes' do
    it '#default_logger' do
      described_class.default_logger == Rails.logger
    end

    it '#default_config_file' do
      path_to_file = described_class.default_config_file
      expect(path_to_file).to include('config/metadata_profile/')
    end
  end
end
