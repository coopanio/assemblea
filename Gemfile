# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'jbuilder', '~> 2.7'
gem 'puma', '~> 5.3'
gem 'rails', '~> 6.1.0', '>= 6.1.3.2'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.2.1'

gem 'hashids'
gem 'hiredis'
gem 'paper_trail'
gem 'pundit'
gem 'redis'
gem 'sentry-raven'
gem 'store_model'

gem 'bootstrap', '~> 5.0.0.beta2'

group :production do
  gem 'connection_pool'
  gem 'pg'
  gem 'sucker_punch'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails'
  gem 'sqlite3', '~> 1.4'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'rubocop', require: false
  gem 'rubocop-minitest', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'factory_bot'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'policy-assertions'
  gem 'selenium-webdriver'
  gem 'timecop'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
