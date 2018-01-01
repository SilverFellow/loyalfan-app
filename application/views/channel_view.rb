# frozen_string_literal: true

module LoyalFan
  module Views
    class AllClips
      def initialize(channel)
        @channel = channel
      end

      def none?
        @channel.clips.none?
      end

      def any?
        @channel.clips.any?
      end

      def data
        @channel
      end

      def embed_clip
        tmp_arr = []
        
        @channel.clips.each do |clip_data|
          tmp_h = {}
          tmp = clip_data.url.sub! 'https://clips.twitch.tv/',''
          tmp = tmp.sub! '?tt_medium=clips_api&tt_content=url',''
          tmp_h[:url] = tmp
          # tmp = "https://clips.twitch.tv/embed?clip="+tmp+"&tt_medium=clips_api&tt_content=embed"
          # tmp[:player] = tmp
          tmp_h[:preview] = clip_data.preview
          tmp_h[:title] = clip_data.title
          tmp_arr << tmp_h
        end
        tmp_arr
      end
      def channel_stream_url
        # p @channel.url[21...-1]
        "http://player.twitch.tv/?channel="+@channel.url[21..-1]+"&muted=true"
      end
      
      def name
        @channel.name
      end

      def loading?
        return true if ws_channel_id
        false
      end

      def ws_channel_id
        @channel.id
      end

      def ws_host
        App.config.API_HOST
      end
    end
  end
end
