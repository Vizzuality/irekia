# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "pg_search"
  s.version = "0.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Case Commons, LLC"]
  s.date = "2011-10-22"
  s.description = "PgSearch builds ActiveRecord named scopes that take advantage of PostgreSQL's full text search"
  s.email = ["casecommons-dev@googlegroups.com"]
  s.homepage = "https://github.com/Casecommons/pg_search"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "PgSearch builds ActiveRecord named scopes that take advantage of PostgreSQL's full text search"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3"])
    else
      s.add_dependency(%q<activerecord>, [">= 3"])
      s.add_dependency(%q<activesupport>, [">= 3"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3"])
    s.add_dependency(%q<activesupport>, [">= 3"])
  end
end
