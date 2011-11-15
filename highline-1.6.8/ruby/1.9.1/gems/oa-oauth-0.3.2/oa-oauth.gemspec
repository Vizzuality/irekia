# encoding: utf-8
require File.expand_path('../lib/omniauth/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'faraday', '~> 0.7.3'
  gem.add_dependency 'multi_json', '~> 1.0.0'
  gem.add_dependency 'multi_xml', '~> 0.4.0'
  gem.add_dependency 'oa-core', OmniAuth::Version::STRING
  gem.add_dependency 'oauth', '~> 0.4.0'
  gem.add_dependency 'oauth2', '~> 0.5.0'
  gem.add_development_dependency 'evernote', '~> 1.0'
  gem.add_development_dependency 'rack-test', '~> 0.5'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rdiscount', '~> 1.6'
  gem.add_development_dependency 'rspec', '~> 2.5'
  gem.add_development_dependency 'simplecov', '~> 0.4'
  gem.add_development_dependency 'vcr', '~> 1.10'
  gem.add_development_dependency 'webmock', '~> 1.7'
  gem.add_development_dependency 'yard', '~> 0.7'
  gem.authors = ['Michael Bleigh', 'Erik Michaels-Ober']
  gem.description = %q{OAuth strategies for OmniAuth.}
  gem.email = ['michael@intridea.com', 'sferik@gmail.com']
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'http://github.com/intridea/omniauth'
  gem.name = 'oa-oauth'
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if gem.respond_to? :required_rubygems_version=
  gem.summary = gem.description
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = OmniAuth::Version::STRING
end
