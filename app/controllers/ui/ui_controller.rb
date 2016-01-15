module UI
module Show
  def self.registered(app)
    app_get_show = lambda do
      if !authorized?
        slim :login
      else
        redirect '/show/new_items?' + request.query_string
      end
    end

    new_items = lambda do
      redirect '/' unless authorized?
      fetch_record 'latest', params
      slim :list_results
    end

    popular = lambda do
      redirect '/' unless authorized?
      fetch_record 'popular', params
      slim :list_results
    end

    pants = lambda do
      redirect '/' unless authorized?
      fetch_record 'pants', params
      slim :list_results
    end

    accessories = lambda do
      redirect '/' unless authorized?
      fetch_record 'accessories', params
      slim :list_results
    end

    tops = lambda do
      redirect '/' unless authorized?
      fetch_record 'tops', params
      slim :list_results
    end

    pinned_items = lambda do
      redirect '/' unless authorized?
      request_url = get_api_url("/user_pinned_items")
      options = { headers: { 'Content-Type' => 'application/json' },
        body: { "email_address": "#{session[:email_address]}" }.to_json
      }
      @products = HTTParty.post(request_url, options)
      slim :list_results
    end

    search = lambda do
      redirect '/' unless authorized?
      request_url = get_api_url("/get_items")
      price = URI.decode(params["price"])
      keyword = URI.decode(params["keyword"])

      options = { headers: { 'Content-Type' => 'application/json' },
        body: { "prices": "#{price}", "keywords": "#{keyword}" }.to_json
      }

      data = HTTParty.post(request_url, options)
      puts data
      @products = []
      @channel_id = data["channel_id"]
      @faye_url = "#{settings.api_server}/faye"
      slim :list_results
    end

    # routes
    app.get '/?', &app_get_show
    #app.get ':item', &app_get_show
    #app.get '/:item', &app_get_show_item
    app.get '/new_items?', &new_items
    app.get '/popular?', &popular
    app.get '/pants?', &pants
    app.get '/accessories?', &accessories
    app.get '/tops?', &tops
    app.get '/pinned_items?', &pinned_items
    app.get '/search?', &search
  end
end
end
