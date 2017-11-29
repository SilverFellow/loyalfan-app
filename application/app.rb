# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'json'

module LoyalFan
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'presentation/views'
    plugin :assets, css: 'style.css', path: 'presentation/assets'
    plugin :flash

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    route do |routing|
      routing.assets
      app = App

      # GET / request
      routing.root do
        # clips_json = ApiGateway.new.channel('shroud')
        # p clips_json
        # games = LoyalFan::GameRepresenter.new(OpenStruct.new)
                                        #  .from_json(clips_json)
        # p games
        view 'home'
      end

      routing.on 'channel' do
        routing.post do
          streamer_name = routing.params['streamer_name'].downcase
          result = ApiGateway.new.create_channel(streamer_name)
          result_json = JSON.parse(result)
          if result_json.key?("error") # if error occur
            error_msg = result_json["error"].to_s[2...-2]
            p error_msg
            if error_msg.include?("not found")
              flash[:error] = streamer_name+" "+error_msg.to_s
              routing.redirect '/'
            end
            flash[:notice] = error_msg
            routing.redirect "/channel/#{streamer_name}"
          end
          
         end

        routing.on String do |streamer_name|
          clips_json = ApiGateway.new.channel(streamer_name)
          games = LoyalFan::GameRepresenter.new(OpenStruct.new)
                                           .from_json(clips_json)
          p games
          view 'channel', locals: { clip: games }
        
        end
      end
    end
  end
end
