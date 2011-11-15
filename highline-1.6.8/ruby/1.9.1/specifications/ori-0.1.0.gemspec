# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ori"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Fortuna"]
  s.date = "2011-01-01"
  s.description = "Object-Oriented RI for IRB Console"
  s.email = "alex.r@askit.org"
  s.extra_rdoc_files = ["README.html", "README.md"]
  s.files = ["README.html", "README.md"]
  s.homepage = "http://github.com/dadooda/ori"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Object-Oriented RI for IRB Console"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
