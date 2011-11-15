# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rails-footnotes/version"

Gem::Specification.new do |s|
  s.name        = "rails-footnotes"
  s.version     = Footnotes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Keenan Brock"]
  s.email       = ["keenan@thebrocks.net"]
  s.homepage    = "http://github.com/josevalim/rails-footnotes"
  s.summary     = %q{Every Rails page has footnotes that gives information about your application and links back to your editor.}
  s.description = %q{Every Rails page has footnotes that gives information about your application and links back to your editor.}

  s.rubyforge_project = "rails-footnotes"

  s.add_dependency "rails", ">= 3.0.0"

  s.add_development_dependency "rails", ">= 3.0.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "watchr"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

