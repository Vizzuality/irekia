# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem

Gem::Specification.new do |s|
  s.name = 'rvm_loader'
  s.version = '1.0.0'
  s.author                = "Jan Lelis"
  s.summary               = "Loads the RVM Ruby API"
  s.description           = "Loads the RVM Ruby API or raises an error: require 'rvm_loader'"
  s.email                 = "mail@janlelis.de"
  s.files                 = %w[lib/rvm_loader.rb rvm_loader.gemspec]
  s.homepage              = %q[http://blog.thefrontiergroup.com.au/2010/12/a-brief-introduction-to-the-rvm-ruby-api/]
end
