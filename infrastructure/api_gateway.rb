# frozen_string_literal: true

require 'http'

module LoyalFan
  class ApiGateway
    def initialize(config = LoyalFan::App.config)
      @config = config
    end

    # def all_repos
    #   call_api(:get, 'repo')
    # end

    def channel(channelname)
      call_api(:get, ['channel', channelname])
    end

    def create_channel(channelname)
      call_api(:post, ['channel', channelname])
    end

    def game(gamename)
      call_api(:get, ['game', gamename])
    end

    def create_game(gamename)
      call_api(:post, ['game', gamename])
    end

    # def repo(username, reponame)
    #   call_api(:get, ['repo', username, reponame])
    # end

    # def create_repo(username, reponame)
    #   call_api(:post, ['repo', username, reponame])
    # end

    def call_api(method, resources)
      url_route = [@config.api_url, resources].flatten.join('/')

      result = HTTP.send(method, url_route)
      raise(result.to_s) if result.code >= 300
      result.to_s
    end
  end
end
