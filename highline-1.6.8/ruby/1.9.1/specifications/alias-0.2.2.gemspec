# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "alias"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gabriel Horner"]
  s.date = "2010-06-11"
  s.description = "Creates aliases for class methods, instance methods, constants, delegated methods and more. Aliases can be easily searched or saved as YAML config files to load later. Custom alias types are easy to create with the DSL Alias provides.  Although Alias was created with the irb user in mind, any Ruby console program can hook into Alias for creating configurable aliases."
  s.email = "gabriel.horner@gmail.com"
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.files = ["README.rdoc", "LICENSE.txt"]
  s.homepage = "http://tagaholic.me/alias/"
  s.require_paths = ["lib"]
  s.rubyforge_project = "tagaholic"
  s.rubygems_version = "1.8.10"
  s.summary = "Creates, manages and saves aliases for class methods, instance methods, constants, delegated methods and more."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bacon>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<mocha-on-bacon>, [">= 0"])
    else
      s.add_dependency(%q<bacon>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<mocha-on-bacon>, [">= 0"])
    end
  else
    s.add_dependency(%q<bacon>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<mocha-on-bacon>, [">= 0"])
  end
end
