# frozen_string_literal: false
# folders = %w[representers forms services views controllers]
folders = %w[representers forms services views controllers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end

# require_relative 'app.rb'
