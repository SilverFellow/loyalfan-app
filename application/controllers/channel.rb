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
    plugin :halt
    
    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    route('channel') do |routing|
      routing.assets
      app = App
      routing.post do
        validated_input = Forms::UrlRequest.call(routing.params)
        result = AddChannel.new.call(validated_input)

        if result.success?
          flash[:notice] = 'Channel Found!'
        else
          flash[:error] = result.value
          routing.redirect '/'
        end
        streamer_name = result.value[:name]
        routing.redirect "/channel/#{streamer_name}"
      end

      # Channel Data Presentation
      routing.on String do |streamer_name|
        routing.on 'video' do
          routing.on String do |video_id|
            clips_json = ApiGateway.new.channel(streamer_name)
            
            info = LoyalFan::ChannelRepresenter.new(OpenStruct.new).from_json(clips_json)
            clips = Views::AllClips.new(info)
            view 'video', locals: { channel: clips ,name: streamer_name ,video_id: video_id}
          end
        end
        routing.get do
          clips_json = ApiGateway.new.channel(streamer_name)
          # p clips_json
          info = LoyalFan::ChannelRepresenter.new(OpenStruct.new).from_json(clips_json)
          clips = Views::AllClips.new(info)
          # p clips.any?
          if clips.none?
            p "ASD"
          end
          view 'channel', locals: { channel: clips ,name: streamer_name}
        end

        # START OF CLIP REPRESENTATION
        
      end

    end
  end
end
