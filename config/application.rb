# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

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

# Load all of our ActiveRecord::Base objects.
Dir[File.expand_path('../app/models/*.rb', __dir__)].sort.each do |f|
  require f
end

Dir[File.join(__dir__, '../app/**/*.rb')].sort.each do |file|
  require file
end

connection_details = YAML.safe_load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection connection_details
ActiveRecord::Base.logger = Logger.new($stdout)

require_relative 'initializers/sidekiq'
