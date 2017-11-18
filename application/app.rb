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
        repos_json = ApiGateway.new.game("csgo")
        games = LoyalFan::GameRepresenter.new(OpenStruct.new)
                                                .from_json repos_json
        p games                                
        view 'home', locals: { game: games}
      end

      routing.on 'game' do
        routing.post do
          gh_url = routing.params['github_url'].downcase
          halt 400 unless (gh_url.include? 'github.com') &&
                          (gh_url.split('/').count > 2)
          ownername, reponame = gh_url.split('/')[-2..-1]
          ApiGateway.new.create_repo(ownername, reponame)
        end
      end
    end
  end
end
