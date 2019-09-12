require 'rubygems'
require 'bundler/setup'
module Environment
  def self.env
    @env ||= (ENV['RACK_ENV'] || 'development').to_sym
  end  
end
require File.expand_path('../application', __FILE__)
require 'openssl'