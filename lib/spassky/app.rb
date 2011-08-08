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
      test_run = TestRun.find_next_to_run_for_user_agent(request.user_agent)

      if test_run
        redirect "/test_runs/#{test_run.id}/run/#{RandomStringGenerator.random_string}"
      else
        url = "/device/idle/" + RandomStringGenerator.random_string
        meta_refresh = "<meta http-equiv=\"refresh\" content=\"#{seconds}; url='#{url}'\">"
        "<html><head>#{meta_refresh}</head></html>"
      end
    end
    
    post '/test_runs' do
      TestRun.create({:name => params[:name], :contents => params[:contents]})
      redirect "/test_runs/#{RandomStringGenerator.random_string}"
    end
    
    get '/test_runs/:id' do
      TestRun.find(params[:id]).status
    end
    
    get '/test_runs/:id/run/:random' do
      seconds = 1
      test_run = TestRun.find(params[:id])
      assert_js_contents  = File.read(File.join(File.dirname(__FILE__), 'assert.js'))
      assert_js_with_script_tag ="<script type=\"text/javascript\">#{assert_js_contents}</script>"
      url = "/device/idle/" + RandomStringGenerator.random_string
      meta_refresh = "<meta http-equiv=\"refresh\" content=\"#{seconds}; url='#{url}'\">"
      test_run.contents.gsub('</head>', assert_js_with_script_tag + meta_refresh + '</head>')
    end
  end
end