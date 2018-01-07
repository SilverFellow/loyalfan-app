# frozen_string_literal: true

require 'dry-validation'

module LoyalFan
  module Forms
    UrlRequest = Dry::Validation.Form do
      # URL_REGEX = %r{\w}
      URL_REGEX = %r{\w}

      required(:streamer_name).filled(format?: URL_REGEX)

      configure do
        config.messages_file = File.join(__dir__, 'errors/url_request.yml')
      end
    end
  end
end
