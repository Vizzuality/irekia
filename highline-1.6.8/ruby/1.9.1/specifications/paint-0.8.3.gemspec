# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "paint"
  s.version = "0.8.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jan Lelis"]
  s.date = "2011-07-10"
  s.description = "Terminal painter / no string extensions / 256 color support / effect support / define custom shortcuts / basic usage: Paint['string', :red, :bright]"
  s.email = "mail@janlelis.de"
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.files = ["README.rdoc", "LICENSE.txt"]
  s.homepage = "https://github.com/janlelis/paint"
  s.licenses = ["MIT"]
  s.post_install_message = "       \u{e2}\u{94}\u{8c}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80} info \u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{90}\n J-_-L \u{e2}\u{94}\u{82} https://github.com/janlelis/paint \u{e2}\u{94}\u{82}\n       \u{e2}\u{94}\u{9c}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80} usage \u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{a4}\n       \u{e2}\u{94}\u{82} require 'paint'                   \u{e2}\u{94}\u{82}\n       \u{e2}\u{94}\u{82} puts Paint['J-_-L', :red] # \e[31mJ-_-L\e[0m \u{e2}\u{94}\u{82}\n       \u{e2}\u{94}\u{94}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{98}"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "1.8.10"
  s.summary = "Terminal painter!"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rspec-core>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rainbow>, [">= 0"])
      s.add_development_dependency(%q<term-ansicolor>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rspec-core>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rainbow>, [">= 0"])
      s.add_dependency(%q<term-ansicolor>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rspec-core>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rainbow>, [">= 0"])
    s.add_dependency(%q<term-ansicolor>, [">= 0"])
  end
end
