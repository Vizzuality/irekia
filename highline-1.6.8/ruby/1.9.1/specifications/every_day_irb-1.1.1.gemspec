# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "every_day_irb"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jan Lelis"]
  s.date = "2011-11-01"
  s.description = "every_day_irb defines some helper methods that might be useful in every-day irb usage, e.g.: ls, cat, rq, rrq, ld, session_history, reset!, clear, dbg"
  s.email = "mail@janlelis.de"
  s.extra_rdoc_files = ["LICENSE"]
  s.files = ["LICENSE"]
  s.homepage = "http://github.com/janlelis/irbtools"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "1.8.10"
  s.summary = "every_day_irb defines some helper methods that might be useful in irb."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
