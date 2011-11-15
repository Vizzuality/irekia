# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rails-footnotes"
  s.version = "3.7.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Keenan Brock"]
  s.date = "2011-09-30"
  s.description = "Every Rails page has footnotes that gives information about your application and links back to your editor."
  s.email = ["keenan@thebrocks.net"]
  s.homepage = "http://github.com/josevalim/rails-footnotes"
  s.require_paths = ["lib"]
  s.rubyforge_project = "rails-footnotes"
  s.rubygems_version = "1.8.10"
  s.summary = "Every Rails page has footnotes that gives information about your application and links back to your editor."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.0.0"])
      s.add_development_dependency(%q<rails>, [">= 3.0.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<watchr>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<watchr>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<watchr>, [">= 0"])
  end
end
