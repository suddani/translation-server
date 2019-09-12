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
class Application < Grape::API
  # use Wrapper, wrapped: Rack::Session::Pool,
  #              secret: 'super secret',
  #              key: 'rack.session',
  #              domain: 'daniel-mariia.wedding',
  #              expire_after: 2592000
  use Rack::Session::Cookie,
               secret: ENV['WEB_SESSIONS_SECRET'],
               key: 'rack.session',
               domain: 'daniel-mariia.wedding',
               expire_after: 2592000
  use Rack::Reloader if Environment.env == :development
  before do
    # CORS
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'
    header['Access-Control-Allow-Headers'] = '*'
  end if Environment.env == :development
  helpers do
    def session
      env['rack.session']
    end
    def permitted_params
      declared params
    end
  end
  AUTO_LOAD_PATHS = [
    'api',
    'services',
    'repositories',
    'entities'
  ]
  def self.mount_apis
    mount Routes
  end
  def self.boot_application
    AUTO_LOAD_PATHS.each do |path|
      Dir[File.join(File.expand_path("../#{path}", __dir__),'**/*.rb')].each do |file|
        require file
      end
    end
    require File.expand_path("./routes", __dir__)
    mount_apis
  end
end
Application.boot_application