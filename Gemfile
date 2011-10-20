source 'http://rubygems.org'

gem 'rails', '~> 3.0.10'
gem 'sass', '~> 3.1.7'
gem 'pg', '0.11.0'
gem 'oa-oauth', '0.2.6', :require => "omniauth/oauth"
gem 'devise', '~> 1.4.7'
gem 'carrierwave', '~> 0.5.7'
gem 'mini_magick', '~> 3.3'
gem 'kaminari', '~> 0.12.4'
gem 'activerecord-postgis-adapter'
gem 'geocoder', '~> 1.0.4'
gem 'colored', '~> 1.2'
gem 'pg_search', '~> 0.3.1'
gem 'json', '1.5.3'
gem 'ffaker', '1.8.1'

group :development do
  gem 'capistrano'
  gem 'capistrano-ext'
end

group :development, :test do
  gem 'ruby-debug19', :platforms => :mri_19
  gem 'rspec-rails', '~> 2.6'
  gem 'capybara', '~> 1.0.1'
  gem 'selenium-webdriver', '2.7.0'
  gem 'spork'
  gem 'launchy'
  gem 'irbtools', :require => 'irbtools/configure'
  gem 'railroady'
  gem 'escape_utils'
  gem 'compass'
  gem 'rails-footnotes', '>= 3.7.5.rc4'
  gem 'bullet'
  gem 'ruby-prof'
  gem 'newrelic_rpm'
end

group :development, :test, :staging do
  gem 'delorean'
end
