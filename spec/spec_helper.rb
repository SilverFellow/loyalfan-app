ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'watir'
require 'headless'
# require 'selenium-webdriver'

require './init.rb'

HOST = 'http://localhost:9000'

def homepage
  HOST
end    
