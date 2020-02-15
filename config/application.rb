require 'yaml'
require 'erb'

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
    # header['Access-Control-Request-Method'] = 'p'
    header['Access-Control-Request-Methods'] = '*'
    header['Access-Control-Allow-Methods'] = '*'
    header['Access-Control-Allow-Headers'] = '*'
  end if Environment.env == :development

  before do
    @context ||= GlobalContext.new(
      params: params,
      cookies: cookies,
      session: env["rack.session"],
      jwk_repository: ListJsonWebKey)
  end

  rescue_from GlobalContext::Error do |e|
    error!({
      status: e.code,
      error: e.message
    }, e.code)
  end

  helpers do
    def session
      env['rack.session']
    end
    def permitted_params
      return @permitted_params if defined?(@permitted_params)
      @permitted_params = declared(params)
      @permitted_params.delete(:jwt)
      @permitted_params[:context] = @context
      @permitted_params
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
      files = Dir[File.join(File.expand_path("../#{path}", __dir__),'**/*.rb')]
      files.select {|file| file.match(/types\.rb$/)}.each do |file|
        require file
      end
      files.select {|file| file.match(/helper\.rb$/)}.each do |file|
        require file
      end
      files.reject {|file| file.match(/types\.rb$/)}.reject {|file| file.match(/helper\.rb$/)}.each do |file|
        require file
      end
    end
    require File.expand_path("./routes", __dir__)
    mount_apis
  end
  def self.database_config
    @database_config ||= YAML.load(ERB.new(File.read('config/database.yml')).result(binding))[Environment.env]
  end
end
Application.boot_application