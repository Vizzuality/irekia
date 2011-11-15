# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "method_locator"
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan LeCompte"]
  s.date = "2011-10-13"
  s.description = "method_locator provides a way to traverse an object's method lookup path to find all places where a method may be defined."
  s.email = ["lecompte@gmail.com"]
  s.homepage = "http://github.com/ryanlecompte/method_locator"
  s.require_paths = ["lib"]
  s.rubyforge_project = "method_locator"
  s.rubygems_version = "1.8.10"
  s.summary = "method_locator provides a way to traverse an object's method lookup path to find all places where a method may be defined."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.5.0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.5.0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.5.0"])
  end
end
