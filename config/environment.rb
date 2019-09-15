require 'rubygems'
require 'bundler/setup'
module Environment
  def self.env
    @env ||= (ENV['RACK_ENV'] || 'development').to_sym
  end  
end
if defined?(Bundler)
  # we can't use the default Rails behaviour because of our
  # environments
  groups = [:default, Environment.env]
  case
  when /development/.match?(Environment.env)
    groups += ['development']
  when /test/.match?(Environment.env) # MTODO: this hits prepare_test too (bad)
    groups += ['test']
  when /production/.match?(Environment.env)
    groups += ['production']
  else # this is for staging, install, translation, project
    groups += ['production']
  end
  groups = groups.uniq
  Bundler.require(*groups)
end
Dotenv.load('.env', ".env.#{Environment.env}", ".env.#{Environment.env}.local")
class Wrapper
  def self.Pool(pool=nil)
    @Pool ||= pool
  end
  def initialize(app, *args, &block)
    @app = app
    self.class.Pool(args.first[:wrapped].new(app, args.first)) unless self.class.Pool
  end
  def call(env)
    self.class.Pool.context(env, @app)
  end
end
require File.expand_path('../application', __FILE__)
require 'openssl'