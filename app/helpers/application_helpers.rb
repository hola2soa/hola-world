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
      redirect '/show'
    else
      error_send( '/', 'Failed to authenticate' ) unless result['authorized'] == true
    end
  end

  def logout!
    session.clear
  end

end
