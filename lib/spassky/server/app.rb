require 'sinatra/base'
require 'spassky/server/random_string_generator'
require 'spassky/server/test_run'
require 'spassky/server/device_list'
require 'spassky/server/html_test'

module Spassky::Server
  class App < Sinatra::Base
    def initialize(device_list=DeviceList.new)
      @device_list = device_list
      super()
    end
    
    get "/devices/clear" do
      @device_list.clear
    end
    
    get '/device/connect' do
      redirect idle_url
    end

    get '/device/idle/:random' do
      test_run = TestRun.find_next_to_run_for_user_agent(request.user_agent)
      @device_list.update_last_connected(request.user_agent)
      if test_run
        run_test(test_run)
      else
        stay_in_meta_refresh_loop
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
      run = TestRun.find(params[:id])
      run.update_connected_devices(@device_list.recently_connected_devices)
      run.result.to_json
    end

    get '/test_runs/:id/run/assert' do
      TestRun.find(params[:id]).save_results_for_user_agent(
        :user_agent => request.user_agent,
        :status => params[:status]
      )
    end

    get '/test_runs/:id/run/:random' do
      test_run = TestRun.find(params[:id])
      html_test = HtmlTest.new(test_run.contents)
      html_test.add_meta_refresh_tag("/device/idle/" + RandomStringGenerator.random_string, 1)
      html_test.html
    end
    
    private
    
    def run_test(test_run)
      redirect "/test_runs/#{test_run.id}/run/#{RandomStringGenerator.random_string}"
    end
    
    def idle_url
      "/device/idle/" + RandomStringGenerator.random_string
    end
    
    def stay_in_meta_refresh_loop
      "<html><head><meta http-equiv=\"refresh\" content=\"1; url='#{idle_url}'\"></head></html>"
    end
  end
end
