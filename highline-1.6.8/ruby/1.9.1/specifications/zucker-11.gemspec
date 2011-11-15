# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "zucker"
  s.version = "11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jan Lelis", "others"]
  s.date = "2011-05-26"
  s.description = "Sweetens your Ruby code with syntactic sugar :).\nAdds a lot of little helpers that you do not want to miss again."
  s.email = "mail@janlelis.de"
  s.homepage = "http://rubyzucker.info"
  s.licenses = ["MIT"]
  s.post_install_message = "       \u{e2}\u{94}\u{8c}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80} info \u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{90}\n J-_-L \u{e2}\u{94}\u{82} http://rubyzucker.info \u{e2}\u{94}\u{82}\n       \u{e2}\u{94}\u{9c}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80} usage \u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{a4}\n       \u{e2}\u{94}\u{82} require 'zucker/all'   \u{e2}\u{94}\u{82}\n       \u{e2}\u{94}\u{82} # or                   \u{e2}\u{94}\u{82}\n       \u{e2}\u{94}\u{82} require 'zucker/<name> \u{e2}\u{94}\u{82}\n       \u{e2}\u{94}\u{94}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{98}"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "1.8.10"
  s.summary = "Many little helpers that sweeten your Ruby code :)."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<coderay>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<coderay>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<coderay>, [">= 0"])
  end
end
