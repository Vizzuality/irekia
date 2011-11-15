# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "irbtools"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jan Lelis"]
  s.date = "2011-11-01"
  s.description = "irbtools is a \"meta gem\" that installs a bnuch of useful irb gems and configures them for you. Simply put a require \"irbtools\" in the .irbrc file in your home directory."
  s.email = "mail@janlelis.de"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc"]
  s.homepage = "https://github.com/janlelis/irbtools"
  s.post_install_message = "       \u{250c}\u{2500}\u{2500} info \u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2510}\n J-_-L \u{2502} https://github.com/janlelis/irbtools \u{2502}\n       \u{251c}\u{2500}\u{2500} usage \u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2524}\n       \u{2502} require 'irbtools'                   \u{2502}\n       \u{2514}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2500}\u{2518}"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "1.8.10"
  s.summary = "irbtools is a \"meta gem\" that installs a bunch of useful irb gems and configures them for you."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<paint>, [">= 0.8.3"])
      s.add_runtime_dependency(%q<fancy_irb>, [">= 0.7.2"])
      s.add_runtime_dependency(%q<zucker>, [">= 11"])
      s.add_runtime_dependency(%q<hirb>, ["~> 0.5.0"])
      s.add_runtime_dependency(%q<awesome_print>, ["~> 0.4.0"])
      s.add_runtime_dependency(%q<clipboard>, [">= 0.9.9"])
      s.add_runtime_dependency(%q<coderay>, ["~> 1.0.0"])
      s.add_runtime_dependency(%q<boson>, [">= 0.3.4"])
      s.add_runtime_dependency(%q<wirb>, [">= 0.4.1"])
      s.add_runtime_dependency(%q<interactive_editor>, [">= 0.0.10"])
      s.add_runtime_dependency(%q<ori>, ["~> 0.1.0"])
      s.add_runtime_dependency(%q<sketches>, [">= 0.1.1"])
      s.add_runtime_dependency(%q<g>, [">= 1.4.0"])
      s.add_runtime_dependency(%q<methodfinder>, [">= 1.2.3"])
      s.add_runtime_dependency(%q<method_locator>, [">= 0.0.4"])
      s.add_runtime_dependency(%q<method_source>, [">= 0.6.7"])
      s.add_runtime_dependency(%q<looksee>, ["~> 1.0.3"])
      s.add_runtime_dependency(%q<rvm_loader>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<every_day_irb>, [">= 1.1.1"])
    else
      s.add_dependency(%q<paint>, [">= 0.8.3"])
      s.add_dependency(%q<fancy_irb>, [">= 0.7.2"])
      s.add_dependency(%q<zucker>, [">= 11"])
      s.add_dependency(%q<hirb>, ["~> 0.5.0"])
      s.add_dependency(%q<awesome_print>, ["~> 0.4.0"])
      s.add_dependency(%q<clipboard>, [">= 0.9.9"])
      s.add_dependency(%q<coderay>, ["~> 1.0.0"])
      s.add_dependency(%q<boson>, [">= 0.3.4"])
      s.add_dependency(%q<wirb>, [">= 0.4.1"])
      s.add_dependency(%q<interactive_editor>, [">= 0.0.10"])
      s.add_dependency(%q<ori>, ["~> 0.1.0"])
      s.add_dependency(%q<sketches>, [">= 0.1.1"])
      s.add_dependency(%q<g>, [">= 1.4.0"])
      s.add_dependency(%q<methodfinder>, [">= 1.2.3"])
      s.add_dependency(%q<method_locator>, [">= 0.0.4"])
      s.add_dependency(%q<method_source>, [">= 0.6.7"])
      s.add_dependency(%q<looksee>, ["~> 1.0.3"])
      s.add_dependency(%q<rvm_loader>, [">= 1.0.0"])
      s.add_dependency(%q<every_day_irb>, [">= 1.1.1"])
    end
  else
    s.add_dependency(%q<paint>, [">= 0.8.3"])
    s.add_dependency(%q<fancy_irb>, [">= 0.7.2"])
    s.add_dependency(%q<zucker>, [">= 11"])
    s.add_dependency(%q<hirb>, ["~> 0.5.0"])
    s.add_dependency(%q<awesome_print>, ["~> 0.4.0"])
    s.add_dependency(%q<clipboard>, [">= 0.9.9"])
    s.add_dependency(%q<coderay>, ["~> 1.0.0"])
    s.add_dependency(%q<boson>, [">= 0.3.4"])
    s.add_dependency(%q<wirb>, [">= 0.4.1"])
    s.add_dependency(%q<interactive_editor>, [">= 0.0.10"])
    s.add_dependency(%q<ori>, ["~> 0.1.0"])
    s.add_dependency(%q<sketches>, [">= 0.1.1"])
    s.add_dependency(%q<g>, [">= 1.4.0"])
    s.add_dependency(%q<methodfinder>, [">= 1.2.3"])
    s.add_dependency(%q<method_locator>, [">= 0.0.4"])
    s.add_dependency(%q<method_source>, [">= 0.6.7"])
    s.add_dependency(%q<looksee>, ["~> 1.0.3"])
    s.add_dependency(%q<rvm_loader>, [">= 1.0.0"])
    s.add_dependency(%q<every_day_irb>, [">= 1.1.1"])
  end
end
