Dir.glob('./app/{helpers,forms,services}/*.rb').each { |file| require file }

class SinatraApp < Sinatra::Base
  use Rack::Session::Pool
  use Rack::Flash
  use Rack::MethodOverride
  helpers ApplicationHelpers

  # set path to view/public
  set :views, File.expand_path('../app/views', __FILE__) # ok
  set :public_folder, File.expand_path('../app/public', __FILE__)

  configure do
    set :api_ver, '/api/v1/'
  end

  configure :production do
    set :api_server, 'https://wss-dynamo.herokuapp.com'
  end

  # Standard Sinatra configurations
  configure :production, :development do
    enable :logging
    set :api_server, 'http://localhost:9292'
  end
end
