# frozen_string_literal: true

require 'dry/transaction'
require 'json'

module LoyalFan
  # Transaction to add Github project to API
  class AddChannel
    include Dry::Transaction

    step :validate_input
    step :add_channel
    step :check_error_return

    def validate_input(input)
      if input.success?
        streamer_name = input[:streamer_name]
        Right(streamer_name: streamer_name)
      else
        Left(input.errors.values.join('; '))
      end
    end

    def add_channel(input)
      res = ApiGateway.new.create_channel(input[:streamer_name])
      Right(result: res, name: input[:streamer_name])
    rescue StandardError => error
      Left(error.to_s)
    end

    def check_error_return(input)
      result_json = JSON.parse(input[:result])

      if result_json.key?("error") # if error occur
        error_msg = result_json["error"].to_s[2...-2]
        Left(error_msg)
      else
        Right(result: result_json, name: input[:name])      
      end
    end
  end
end