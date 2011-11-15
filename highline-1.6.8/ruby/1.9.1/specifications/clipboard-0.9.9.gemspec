# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "clipboard"
  s.version = "0.9.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jan Lelis"]
  s.date = "2011-06-23"
  s.description = "Access the clipboard on Linux, MacOS and Windows (Clipboard.copy & Clipboard.paste)."
  s.email = "mail@janlelis.de"
  s.homepage = "http://github.com/janlelis/clipboard"
  s.post_install_message = "       \u{e2}\u{94}\u{8c}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80} info \u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{90}\n J-_-L \u{e2}\u{94}\u{82} http://github.com/janlelis/clipboard \u{e2}\u{94}\u{82}\n       \u{e2}\u{94}\u{9c}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80} usage \u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{a4}\n       \u{e2}\u{94}\u{82} require 'clipboard'                  \u{e2}\u{94}\u{82}\n       \u{e2}\u{94}\u{82} Clipboard.copy '42'                  \u{e2}\u{94}\u{82}\n       \u{e2}\u{94}\u{82} Clipboard.paste #=> 42               \u{e2}\u{94}\u{82}\n       \u{e2}\u{94}\u{94}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{80}\u{e2}\u{94}\u{98}"
  s.require_paths = ["lib"]
  s.requirements = ["On Linux (or other X), you need xclip. You can install it on debian/ubuntu with sudo apt-get install xclip", "On Windows, you need the ffi gem."]
  s.rubygems_version = "1.8.10"
  s.summary = "Access the clipboard on Linux, MacOS and Windows."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2"])
  end
end
