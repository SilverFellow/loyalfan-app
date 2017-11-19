# frozen_string_literal: true

require 'roda'
require 'slim'

module LoyalFan
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'presentation/views'
    plugin :assets, css: 'style.css', path: 'presentation/assets'

    route do |routing|
      routing.assets
      app = App

      # GET / request
      routing.root do
        clips_json = ApiGateway.new.game('csgo')
        games = LoyalFan::GameRepresenter.new(OpenStruct.new)
                                         .from_json(clips_json)
        p games
        view 'home', locals: { game: games }
      end

      routing.on 'channel' do
        routing.post do
          streamer_name = routing.params['streamer_name'].downcase
          ApiGateway.new.create_channel(streamer_name)
        end
      end
    end
  end
end
