# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'allinson_flex/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'allinson_flex'
  s.version     = AllinsonFlex::VERSION
  s.authors     = ['Julie Allinson', 'JP Engstrom', 'Rob Kaufman']
  s.email       = ['support@notch8.com']
  s.homepage    = 'https://github.com/notch8/allinson_flex'
  s.summary     = 'Summary of Allinson Flex.'
  s.description = 'Description of Allinson Flex.'
  s.license     = 'Apache-2.0'

  s.files = Dir["{app,config,db,lib}/**/*", "public/flexible-packs/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '>= 5.1.6'
  s.add_dependency 'solrizer'
  s.add_dependency 'json_schemer'
  s.add_dependency 'webpacker'
  s.add_dependency 'react-rails'

  # TODO: ADD RUBOCOP AS DEPENDENCY? Might need to downgrade version for hyrax?
  s.add_development_dependency 'bixby'
  s.add_development_dependency 'rspec-rails', '~> 3.1'
  s.add_development_dependency 'engine_cart', '~> 2.2'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1'
  s.add_development_dependency 'database_cleaner', '~> 1.3'
end
