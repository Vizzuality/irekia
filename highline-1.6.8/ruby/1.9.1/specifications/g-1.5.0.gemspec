# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "g"
  s.version = "1.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["jugyo"]
  s.date = "2011-11-14"
  s.description = "It works like Kernel.p with growl :)"
  s.email = ["jugyo.org@gmail.com"]
  s.homepage = "http://github.com/jugyo/g"
  s.require_paths = ["lib"]
  s.rubyforge_project = "g"
  s.rubygems_version = "1.8.10"
  s.summary = "The Kernel.g"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby_gntp>, [">= 0"])
    else
      s.add_dependency(%q<ruby_gntp>, [">= 0"])
    end
  else
    s.add_dependency(%q<ruby_gntp>, [">= 0"])
  end
end
