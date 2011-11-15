# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "looksee"
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["George Ogata"]
  s.date = "2011-09-05"
  s.email = ["george.ogata@gmail.com"]
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.markdown"]
  s.files = ["CHANGELOG", "LICENSE", "README.markdown", "ext/extconf.rb"]
  s.homepage = "http://github.com/oggy/looksee"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Supercharged method introspection in IRB."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<ritual>, ["= 0.3.0"])
      s.add_development_dependency(%q<rspec>, ["= 2.5.0"])
      s.add_development_dependency(%q<wirble>, [">= 0"])
    else
      s.add_dependency(%q<ritual>, ["= 0.3.0"])
      s.add_dependency(%q<rspec>, ["= 2.5.0"])
      s.add_dependency(%q<wirble>, [">= 0"])
    end
  else
    s.add_dependency(%q<ritual>, ["= 0.3.0"])
    s.add_dependency(%q<rspec>, ["= 2.5.0"])
    s.add_dependency(%q<wirble>, [">= 0"])
  end
end
