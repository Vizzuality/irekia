# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "awesome_print"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Dvorkin"]
  s.date = "2011-05-13"
  s.description = "Great Ruby dubugging companion: pretty print Ruby objects to visualize their structure. Supports Rails ActiveRecord objects via included mixin."
  s.email = "mike@dvorkin.net"
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.files = ["LICENSE", "README.md"]
  s.homepage = "http://github.com/michaeldv/awesome_print"
  s.require_paths = ["lib"]
  s.rubyforge_project = "awesome_print"
  s.rubygems_version = "1.8.10"
  s.summary = "Pretty print Ruby objects with proper indentation and colors."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 2.5.0"])
    else
      s.add_dependency(%q<rspec>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.5.0"])
  end
end
