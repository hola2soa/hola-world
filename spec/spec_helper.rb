ENV['RACK_ENV'] = 'test'

require ::File.expand_path('../../config/environments', __FILE__)
require 'minitest/autorun'
require 'rack/test'
require 'watir-webdriver'
require 'headless'
require 'page-object'

include Rack::Test::Methods

def app
  SinatraApp
end
