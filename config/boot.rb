# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

Bundler.require :default, ENV['RACK_ENV']

Dir[File.expand_path('../api/*.rb', __dir__)].sort.each do |f|
  require f
end

require 'api'
require 'app'

# Load the required gems/libraries.
require 'logger'
require 'pg'
require 'active_record'
require 'yaml'

Dir[File.join(__dir__, '../app/**/*.rb')].sort.each do |file|
  require file
end

Dir[File.join(__dir__, '../lib/**/*.rb')].sort.each do |file|
  require file
end
