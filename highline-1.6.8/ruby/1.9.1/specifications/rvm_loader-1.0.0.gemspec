# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rvm_loader"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jan Lelis"]
  s.date = "2011-05-14"
  s.description = "Loads the RVM Ruby API or raises an error: require 'rvm_loader'"
  s.email = "mail@janlelis.de"
  s.homepage = "http://blog.thefrontiergroup.com.au/2010/12/a-brief-introduction-to-the-rvm-ruby-api/"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Loads the RVM Ruby API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
