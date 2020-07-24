FactoryBot.define do
  factory :dynamic_schema, class: AllinsonFlex::DynamicSchema do
    allinson_flex_class   { 'Image' }
    allinson_flex_context { FactoryBot.build(:allinson_flex_context_assigned) }
    allinson_flex_profile { FactoryBot.build(:allinson_flex) }
    schema     do
        {
          'type' => 'http://example.com/classes/Image',
          'display_label' => 'Allinson Flex Example',
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
    allinson_flex_class   { 'Image' }
    allinson_flex_context { FactoryBot.build(:allinson_flex_context_default) }
    allinson_flex_profile { FactoryBot.build(:allinson_flex) }
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
