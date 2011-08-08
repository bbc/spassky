require 'sinatra/base'
require 'spassky/random_string_generator'
require 'spassky/test_run'

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
    
    post '/test_runs' do
      TestRun.create({:name => params[:name], :contents => params[:contents]})
      redirect "/test_runs/#{RandomStringGenerator.random_string}"
    end
    
    get '/test_runs/:id' do
      TestRun.find(params[:id]).status
    end
  end
end