module ApplicationHelpers

  def current_page?(path = ' ')
    path_info = request.path_info
    path_info += ' ' if path_info == '/'
    request_path = path_info.split '/'
    request_path[1] == path
  end

  def get_api_url(resource)
    settings.api_server + settings.api_ver + resource
  end

  def array_strip(str_arr)
    str_arr.map(&:strip).reject(&:empty?)
  end

  def error_send(url, msg)
    flash[:error] = msg
    redirect url
    halt 303        # http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
  end

  def fetch_record(category, params)
    redirect '/' unless authorized?

    request_url = get_api_url("?category=#{category}&page_limit=1")
    request_url << "&keyword=#{URI.encode(params["keyword"])}" if params["keyword"]

    options =  { headers: { 'Content-Type' => 'application/json' } }
    results = []
    session[:stores].each do |store|
      results << HTTParty.get(request_url + "&store=#{store}", options)
    end
    @products = results.flatten.compact
    @columnchartdata = chart_data(@products)
    slim :list_results
  end

  def chart_data(items)
    count_0_300 =0
    count_300_600 =0
    count_600_900 =0
    count_900_1200 =0
    count_1200_up =0
    #count number of items each range of price
    items.each do |item|
      if item["price"].to_i <300
        count_0_300 = count_0_300 + 1
      elsif item["price"].to_i <600
        count_300_600 = count_300_600 + 1
      elsif item["price"].to_i <900
        count_600_900 = count_600_900 + 1
      elsif item["price"].to_i <1200
        count_900_1200 = count_900_1200 + 1
      else
        count_1200_up = count_1200_up + 1
      end
    end
    # " "=>0 is used to adjust appearance
    { "0~300"=>count_0_300,"300~600"=>count_300_600,"600~900"=>count_600_900,
      "900~1200"=>count_900_1200,"1200 up"=>count_1200_up," "=>0 }
  end

  def authorized?
    session[:authorized]
  end

  def authorize!
    halt 503, 'Please login to access resource' unless authorized?
  end

  def authorize(req)
    halt 400, 'please provide email address' unless req['email_address']
    request_url = get_api_url("/auth")
    options =  {
      body: req.to_json,
      headers: { 'Content-Type' => 'application/json' }
    }

    result = HTTParty.post(request_url, options)
    if result.code == 200
      error_send( '/', 'Invalid Credentials' ) unless result['authorized'] == true
      session[:authorized] = true
      session[:email_address] = result['user']['email_address']
      session[:stores] = result['user']['stores']
      redirect '/show'
    else
      error_send( '/', 'Failed to authenticate' ) unless result['authorized'] == true
    end
  end

  def logout!
    session.clear
  end

end
