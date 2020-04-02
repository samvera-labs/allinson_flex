# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'flexible_metadata/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'flexible_metadata'
  s.version     = FlexibleMetadata::VERSION
  s.authors     = ['Julie Allinson', 'JP Engstrom']
  s.email       = ['julie@notch8.com']
  s.homepage    = 'https://github.com/notch8/flexible_metadata'
  s.summary     = 'Summary of Flexible Metadata.'
  s.description = 'Description of Flexible Metadata.'
  s.license     = 'Apache-2.0'

  # TODO: Commented out line is from Bulkrax. Is this needed?
  # s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.files = Dir['{lib}/**/*', 'LICENSE', 'README.md']

  s.add_dependency 'rails', '>= 5.1.6'

  # TODO: ADD RUBOCOP AS DEPENDENCY? Might need to downgrade version for hyrax?
  s.add_development_dependency 'bixby'
  s.add_development_dependency 'rspec-rails', '~> 3.1'
  s.add_development_dependency 'engine_cart', '~> 2.2'
end
