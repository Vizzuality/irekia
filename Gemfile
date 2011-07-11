source 'http://rubygems.org'

gem 'rails', '3.0.9'
gem 'sass', '~> 3.1.3'
gem 'pg', '0.11.0'
gem 'devise', '~> 1.4.2'
gem 'carrierwave', '~> 0.5.5'
gem 'mini_magick', '~> 3.3'

group :development do
  gem 'capistrano'
  gem 'capistrano-ext'
end

group :development, :test do
  gem 'ruby-debug19', :platforms => :mri_19
  gem 'rspec-rails', '~> 2.6'
  gem 'capybara', '~> 1.0.0'
  gem 'database_cleaner', '~> 0.6.7'
  gem 'launchy'
  gem 'irbtools', :require => 'irbtools/configure'
  gem 'railroady'
end

group :development, :test, :staging do
  gem 'delorean'
end
