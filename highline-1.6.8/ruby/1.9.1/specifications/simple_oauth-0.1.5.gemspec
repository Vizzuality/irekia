# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "simple_oauth"
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steve Richert", "Erik Michaels-Ober"]
  s.date = "2011-05-06"
  s.description = "Simply builds and verifies OAuth headers"
  s.email = ["steve.richert@gmail.com", "sferik@gmail.com"]
  s.homepage = "http://github.com/laserlemon/simple_oauth"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Simply builds and verifies OAuth headers"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9"])
      s.add_development_dependency(%q<rake>, ["~> 0.8"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.4"])
      s.add_development_dependency(%q<turn>, ["~> 0.8"])
      s.add_development_dependency(%q<yard>, ["~> 0.6"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<mocha>, ["~> 0.9"])
      s.add_dependency(%q<rake>, ["~> 0.8"])
      s.add_dependency(%q<simplecov>, ["~> 0.4"])
      s.add_dependency(%q<turn>, ["~> 0.8"])
      s.add_dependency(%q<yard>, ["~> 0.6"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<mocha>, ["~> 0.9"])
    s.add_dependency(%q<rake>, ["~> 0.8"])
    s.add_dependency(%q<simplecov>, ["~> 0.4"])
    s.add_dependency(%q<turn>, ["~> 0.8"])
    s.add_dependency(%q<yard>, ["~> 0.6"])
  end
end
