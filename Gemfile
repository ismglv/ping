# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '2.6.3'
gem 'activerecord'
gem 'grape'
gem 'json'
gem 'mime-types'
gem 'net-ping'
gem 'newrelic_rpm'
gem 'nokogiri'
gem 'pg'
gem 'puma'
gem 'rack'
gem 'rack-cors'
gem 'sequel'
gem 'sidekiq'
gem 'dry-transaction'
gem 'dry-monads'

group :development do
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rack'
  gem 'rake'
  gem 'rubocop'
end

group :test do
  gem 'capybara'
  gem 'rack-test'
  gem 'rspec'
  gem 'selenium-webdriver'
end
