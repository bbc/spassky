require 'sinatra/base'
require 'spassky/random_string_generator'
require 'spassky/test_run'
require 'spassky/device_list'

module Spassky
  class App < Sinatra::Base
    def initialize(device_list=DeviceList.new)
      @device_list = device_list
      super()
    end
    
    get '/device/connect' do
      redirect '/device/idle/' + RandomStringGenerator.random_string
    end

    get '/device/idle/:random' do
      test_run = TestRun.find_next_to_run_for_user_agent(request.user_agent)
      @device_list.update_last_connected(request.user_agent)
      if test_run
        redirect "/test_runs/#{test_run.id}/run/#{RandomStringGenerator.random_string}"
      else
        url = "/device/idle/" + RandomStringGenerator.random_string
        meta_refresh = "<meta http-equiv=\"refresh\" content=\"1; url='#{url}'\">"
        "<html><head>#{meta_refresh}</head></html>"
      end
    end

    post '/test_runs' do
      run = TestRun.create({
        :name => params[:name],
        :contents => params[:contents],
        :devices => @device_list.recently_connected_devices
      })
      redirect "/test_runs/#{run.id}"
    end

    get '/test_runs/:id' do
      TestRun.find(params[:id]).result.to_json
    end

    get '/test_runs/:id/run/assert' do
      TestRun.find(params[:id]).save_results_for_user_agent(
        :user_agent => request.user_agent,
        :status => params[:status]
      )
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
