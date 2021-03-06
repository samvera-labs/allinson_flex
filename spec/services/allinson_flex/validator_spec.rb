require 'rails_helper'

RSpec.describe AllinsonFlex::Validator do
  
  let(:data) { YAML.load_file( File.join(RSpec.configuration.fixture_path, 'files/yaml_example.yaml')) }
  let(:default_schema) { JSONSchemer.schema(Pathname.new('allinson_flex_schema.json')) }
  let(:default_logger) { Rails.logger }
  
  describe 'valid schema' do
    context 'when imported yaml data is valid' do
      it 'returns true' do
          expect(described_class.validate(data: data, schema: default_schema, logger: default_logger)).to be_truthy 
      end
    end
  end

  describe 'invalid schema' do
    context "when data type is invalid" do
      let(:data) { YAML.load_file(File.join(RSpec.configuration.fixture_path, 'files/yaml_badtype_example.yaml')) }

      before do
        allow(described_class).to receive(:validate).and_raise(AllinsonFlex::Validator::InvalidDataError)
      end

      it "logs error message" do
        expect { described_class.validate(data: data, schema: default_schema, logger: default_logger) }.to raise_error(AllinsonFlex::Validator::InvalidDataError)
      end
      
    end
  end
end
