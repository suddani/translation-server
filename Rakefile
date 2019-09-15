require 'rake'
require './config/environment'

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require "sequel/core"
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    Sequel.connect(Application.database_config) do |db|
      Sequel::Migrator.run(db, "db/migrations", target: version)
    end
  end
end