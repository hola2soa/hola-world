module UI
module Show
  def self.registered(app)
    app_get_show = lambda do
      if !authorized?
        slim :login
      else
        @item = params[:item]
        if @item
          logger.info 'redirected to get items'
          redirect "/show/#{@item}"
          return nil
        end
        logger.info 'load show'
        slim :main_pane
      end
    end

    app_get_show_item = lambda do
      begin
        @item = params[:item]

        if session[:results]
          @results = session[:results]
          session[:results] = nil
        else
          request_url = get_api_url("queenshop/#{@item}")
          options =  { headers: { 'Content-Type' => 'application/json' } }
          @results = HTTParty.get(request_url, options)
        end
        @products = @results
        #intialize counter
        count_0_300 =0
        count_300_600 =0
        count_600_900 =0
        count_900_1200 =0
        count_1200_up =0
        #count number of items each range of price
        @products.each do |product|
          if product["price"].to_i <300
            count_0_300 = count_0_300 + 1
          elsif product["price"].to_i <600
            count_300_600 = count_300_600 + 1
          elsif product["price"].to_i <900
            count_600_900 = count_600_900 + 1
          elsif product["price"].to_i <1200
            count_900_1200 = count_900_1200 + 1
          else
            count_1200_up = count_1200_up + 1
          end
        end
        # " "=>0 is used to adjust appearance
        @columnchartdata={"0~300"=>count_0_300,"300~600"=>count_300_600,"600~900"=>count_600_900,
          "900~1200"=>count_900_1200,"1200 up"=>count_1200_up," "=>0}
        slim :list_results
      rescue => e
        logger.info e
        error_send '/show', 'Could not find query -- perhaps it was deleted?'
      end
    end

    new_items = lambda do
      request_url = get_api_url("")
      options =  { headers: { 'Content-Type' => 'application/json' } }
      @results = HTTParty.get(request_url, options)
    end

    # routes
    app.get '/?', &app_get_show
    app.get ':item', &app_get_show
    app.get '/:item', &app_get_show_item
    app.get '/new_items', &new_items
  end
end
end
