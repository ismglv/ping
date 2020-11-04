# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

Rake.add_rakelib './lib/tasks'

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require File.expand_path('config/environment', __dir__)
end

task routes: :environment do
  ::API.routes.each do |route|
    method = route.request_method.ljust(10)
    path = route.origin
    puts "     #{method} #{path}"
  end
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: %i[rubocop spec]

namespace :db do
  desc 'Migrate the db'
  task :migrate do
    ENV['RACK_ENV'] ||= 'development'
    connection_details = YAML.safe_load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(connection_details)
    ActiveRecord::MigrationContext.new('db/migrate/', ActiveRecord::SchemaMigration).migrate
  end

  desc 'Create the db'
  task :create do
    connection_details = YAML.safe_load(File.open('config/database.yml'))
    admin_connection = connection_details.merge({ 'database' => 'postgres',
                                                  'schema_search_path' => 'public' })
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.create_database(connection_details.fetch('database'))
  end

  desc 'drop the db'
  task :drop do
    connection_details = YAML.safe_load(File.open('config/database.yml'))
    admin_connection = connection_details.merge({ 'database' => 'postgres',
                                                  'schema_search_path' => 'public' })
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.drop_database(connection_details.fetch('database'))
  end

  desc 'Reset the database'
  task reset: %i[drop create migrate]

  desc 'Create a db/schema.rb file that is portable against any DB supported by AR'
  task :schema do
    ActiveRecord::Base.establish_connection(db_config)
    require 'active_record/schema_dumper'
    filename = 'db/schema.rb'
    File.open(filename, 'w:utf-8') do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

  namespace :test do
    desc 'Prepare spec db'
    task :create do
      connection_details = YAML.safe_load(File.open('config/test_database.yml'))
      admin_connection = connection_details.merge({ 'database' => 'postgres',
                                                    'schema_search_path' => 'public' })
      ActiveRecord::Base.establish_connection(admin_connection)
      ActiveRecord::Base.connection.create_database(connection_details.fetch('database'))
    end

    task :migrate do
      connection_details = YAML.safe_load(File.open('config/test_database.yml'))
      ActiveRecord::Base.establish_connection(connection_details)
      ActiveRecord::MigrationContext.new('db/migrate/', ActiveRecord::SchemaMigration).migrate
    end
  end
end

namespace :g do
  desc 'Generate migration'
  task :migration do
    name = ARGV[1] || raise('Specify name: rake g:migration your_migration')
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    path = File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split('_').map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<~EOF
        class #{migration_class} < ActiveRecord::Migration
          def self.up
          end
          def self.down
          end
        end
      EOF
    end

    puts "Migration #{path} created"
    abort # needed stop other tasks
  end
end
