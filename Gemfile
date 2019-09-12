source 'https://rubygems.org'
gem 'bunny'
gem 'connection_pool' # https://github.com/mperham/connection_pool
gem 'rake'
gem 'sqlite3'
gem 'pry'
gem 'grape'
gem 'grape-swagger'
gem 'sequel'
group :development do
  # Code reloading
  # See: https://guides.hanamirb.org/projects/code-reloading
  gem 'shotgun', platforms: :ruby
  gem 'thin'
end
group :test, :development do
  gem 'dotenv', '~> 2.4'
end
group :test do
  gem 'rspec'
end
group :production do
  # gem 'puma'
end
