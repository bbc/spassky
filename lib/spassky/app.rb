require 'sinatra/base'
require 'spassky/random_string_generator'

module Spassky
  class App < Sinatra::Base
    get '/device/connect' do
      redirect '/device/idle/' + RandomStringGenerator.random_string
    end
    
    get '/device/idle/:random' do
      seconds = 1
      url = "/device/idle/" + RandomStringGenerator.random_string
      "<html><head><meta http-equiv=\"refresh\" content=\"#{seconds}; url='#{url}'\"></head></html>"
    end
  end
end