require 'rails_helper'

RSpec.describe FlexibleMetadata::DynamicSchemaService do
  let(:admin_set_id) { AdminSet.find_or_create_default_admin_set_id }
  let(:service) do
    described_class.new(
      admin_set_id: admin_set_id,
      work_class_name: 'Image'
    )
  end
  let(:flexible_metadata_context) { build(:flexible_metadata_context_assigned) }
  let(:default_flexible_metadata_context) { build(:flexible_metadata_context_default) }
  let(:dynamic_schema) { build(:dynamic_schema) }
  let(:default_dynamic_schema) { build(:dynamic_schema_default) }

  before do
    allow(AdminSet).to receive_message_chain(:find, :metadata_context).and_return(flexible_metadata_context)
    allow(FlexibleMetadata::DynamicSchema).to receive(:where).and_return([dynamic_schema])
  end

  describe '#new' do
    context 'admin_set does not have a metadata_context' do
      let(:flexible_metadata_context) { create(:flexible_metadata_context) }

      it 'raises a custom error' do
        expect do
          described_class.new(
            admin_set_id: admin_set_id,
            work_class_name: 'Image'
          ).to raise(FlexibleMetadata::NoFlexibleMetadataContextError)
        end
      end
    end

    context 'admin_set has a metadata_context' do
      it 'returns the dynamic_schema' do
        expect(service.dynamic_schema).to be_a(FlexibleMetadata::DynamicSchema)
      end
    end
  end

  describe 'class methods' do

    before do
      allow(described_class).to receive(:schema).with(work_class_name: Image).and_return(default_dynamic_schema.schema)
    end

    context 'for models' do
      it 'returns the properties for the model' do
        expect(described_class.model_properties(work_class_name: Image)[:title]).to be_a(Hash)
      end
      it 'returns the rdf-type for the model' do
        expect(described_class.rdf_type(work_class_name: Image).to_s).to eq('http://example.com/classes/Image')
      end
    end

    context 'for form and presenter' do
      it 'returns the properties for the model' do
        expect(described_class.default_properties(work_class_name: Image)).to eq([:title, :dynamic_schema])
      end
    end
  end

  describe 'instance methods' do

    context 'for indexers' do
      it 'returns the fields to index' do
        expect(service.indexing_properties).to eq({:dynamic_schema=>["dynamic_schema_tesim"], :title=>["title_tesim", "title_ssm"]})
      end
    end

    context 'for forms' do
      it 'returns the property names' do
        expect(service.property_keys).to eq([:title])
      end
      it 'returns the required fields' do
        expect(service.required_properties).to eq([:title])
      end
    end

    context 'for views' do
      it 'returns the view properties for drawing on _attributes.html.erb' do
        expect(service.view_properties).to eq({ title: { label: 'Title in Context'}})
      end
    end

    context 'for locales' do
      it 'returns the ' do
        expect(service.property_locale(:title, 'label')).to eq('Title in Context')
      end
    end
  end
end
