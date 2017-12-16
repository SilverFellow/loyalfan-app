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

      def channel_stream_url
        # p @channel.url[21...-1]
        "http://player.twitch.tv/?channel="+@channel.url[21..-1]+"&muted=true"
      end
      
      def name
        @channel.name
      end
    end
  end
end
