FactoryBot.define do
  factory :dynamic_schema, class: AllinsonFlex::DynamicSchema do
    flexible_metadata_class   { 'Image' }
    flexible_metadata_context { FactoryBot.build(:flexible_metadata_context_assigned) }
    flexible_metadata_profile { FactoryBot.build(:flexible_metadata) }
    schema     do
        {
          'type' => 'http://example.com/classes/Image',
          'display_label' => 'Flexible Metadata Example',
          'properties' => { 
            'title' => {
              'predicate' => 'http://purl.org/dc/terms/title',
              'display_label' => 'Title in Context',
              'required' => true,
              'singular' => false,
              'indexing' => %w[
                stored_searchable
                facetable
              ]
            } 
          }
        }
    end
  end

  factory :dynamic_schema_default, class: AllinsonFlex::DynamicSchema do
    flexible_metadata_class   { 'Image' }
    flexible_metadata_context { FactoryBot.build(:flexible_metadata_context_default) }
    flexible_metadata_profile { FactoryBot.build(:flexible_metadata) }
    schema     do
      {
        'type' => 'http://example.com/classes/Image',
        'display_label' => 'Default',
        'properties' => { 
          'title' => {
            'predicate' => 'http://purl.org/dc/terms/title',
            'display_label' => 'Title',
            'required' => true,
            'singular' => false,
            'indexing' => %w[
              stored_searchable
              facetable
            ]
          } 
        }
      }
    end
  end
end
