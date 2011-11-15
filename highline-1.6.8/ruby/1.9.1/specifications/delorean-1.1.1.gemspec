# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "delorean"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luismi Cavall\u{c3}\u{a9}", "Sergio Gil"]
  s.date = "2011-11-11"
  s.email = "ballsbreaking@bebanjo.com"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "http://github.com/bebanjo/delorean"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Delorean lets you travel in time with Ruby by mocking Time.now"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<chronic>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3.0"])
      s.add_development_dependency(%q<activesupport>, ["~> 2.3.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<chronic>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 1.3.0"])
      s.add_dependency(%q<activesupport>, ["~> 2.3.0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<chronic>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 1.3.0"])
    s.add_dependency(%q<activesupport>, ["~> 2.3.0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
