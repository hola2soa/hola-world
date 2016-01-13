module UI
  module Root
    def self.registered(app)
      get_root = lambda do
        redirect "/show"
      end

      auth = lambda do
        #req = JSON.parse(request.body.read)
        req = LoginForm.new(params)
        error_send('/', 'Invalid Email') unless req.valid?
        authorize(req)
      end

      logout = lambda do
        logout!
        redirect '/'
      end

      app.get '/?', &get_root
      app.post 'auth', &auth
      app.get 'logout', &logout
    end
  end
end
