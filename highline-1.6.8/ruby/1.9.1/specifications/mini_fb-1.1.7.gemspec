# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mini_fb"
  s.version = "1.1.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Travis Reeder"]
  s.date = "2010-12-13"
  s.description = "Tiny facebook library"
  s.email = "travis@appoxy.com"
  s.extra_rdoc_files = ["LICENSE.txt", "README.markdown"]
  s.files = ["LICENSE.txt", "README.markdown"]
  s.homepage = "http://github.com/appoxy/mini_fb"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Tiny facebook library"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<hashie>, [">= 0"])
    else
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<hashie>, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<hashie>, [">= 0"])
  end
end
