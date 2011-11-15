# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "uniform_notifier"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Huang"]
  s.date = "2010-12-14"
  s.description = "uniform notifier for rails logger, customized logger, javascript alert, javascript console, growl and xmpp"
  s.email = ["flyerhzm@gmail.com"]
  s.homepage = "http://rubygems.org/gems/uniform_notifier"
  s.require_paths = ["lib"]
  s.rubyforge_project = "uniform_notifier"
  s.rubygems_version = "1.8.10"
  s.summary = "uniform notifier for rails logger, customized logger, javascript alert, javascript console, growl and xmpp"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<ruby-growl>, ["= 3.0"])
      s.add_development_dependency(%q<xmpp4r>, ["= 0.5"])
      s.add_development_dependency(%q<rspec>, ["= 2.3.0"])
    else
      s.add_dependency(%q<ruby-growl>, ["= 3.0"])
      s.add_dependency(%q<xmpp4r>, ["= 0.5"])
      s.add_dependency(%q<rspec>, ["= 2.3.0"])
    end
  else
    s.add_dependency(%q<ruby-growl>, ["= 3.0"])
    s.add_dependency(%q<xmpp4r>, ["= 0.5"])
    s.add_dependency(%q<rspec>, ["= 2.3.0"])
  end
end
