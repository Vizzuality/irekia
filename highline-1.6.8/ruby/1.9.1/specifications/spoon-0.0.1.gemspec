# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "spoon"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Charles Oliver Nutter"]
  s.date = "2010-01-10"
  s.description = "Spoon is an FFI binding of the posix_spawn function, providing fork+exec functionality in a single shot."
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Spoon is an FFI binding of the posix_spawn function, providing fork+exec functionality in a single shot."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
