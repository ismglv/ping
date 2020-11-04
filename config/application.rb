# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

puts ENV['RACK_ENV']

connection_details = if ENV['RACK_ENV'] = 'test'
                       YAML.safe_load(File.open('config/test_database.yml'), aliases: true)
                     else
                       YAML.safe_load(File.open('config/database.yml'), aliases: true)
                     end
ActiveRecord::Base.establish_connection connection_details
ActiveRecord::Base.logger = Logger.new($stdout)
