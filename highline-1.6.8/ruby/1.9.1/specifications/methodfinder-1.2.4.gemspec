# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "methodfinder"
  s.version = "1.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Kohl"]
  s.date = "2011-10-25"
  s.email = "citizen428@gmail.com"
  s.homepage = "https://github.com/citizen428/MethodFinder"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "A Smalltalk-like Method Finder for Ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
