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


desc "Export translations"
task :translate, [:project] do |t, args|
  GetTranslationGroups.call(project: args[:project]).each do |lang, namespaces|
    GetTranslationsForLanguage.call(project: args[:project], lang: lang).each do |namespace, translations|
      output = Pathname.new("output/#{args[:project]}/#{lang}")
      output.mkpath
      File.write(output.join("#{namespace}.json"), JSON.pretty_generate(
        Hash[translations.map {|translation| [translation.key, translation.translation]}]
      ))
    end
  end
end