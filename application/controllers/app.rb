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
    plugin :multi_route
    require_relative 'channel'

    use Rack::Session::Cookie, secret: config.SESSION_SECRET
    
    route do |routing|
      routing.assets
      app = App

      # GET / request
      routing.root do
        view 'home'
      end

      @api_root = '/'
      routing.multi_route

      
    end
  end
end
