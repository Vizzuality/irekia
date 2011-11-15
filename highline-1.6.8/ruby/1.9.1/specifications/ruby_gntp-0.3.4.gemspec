# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ruby_gntp"
  s.version = "0.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["snaka", "David Hayward (spidah)"]
  s.date = "2010-02-01"
  s.email = ["snaka.gml@gmail.com", "spidahman@gmail.com"]
  s.homepage = "http://snaka.github.com/ruby_gntp/"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Ruby library for GNTP(Growl Notification Transport Protocol) client"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
