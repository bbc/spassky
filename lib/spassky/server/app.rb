require 'sinatra/base'
require 'spassky/server/random_string_generator'
require 'spassky/server/test_run'
require 'spassky/server/device_list'
require 'spassky/server/html_test'
require 'spassky/server/device_database'

module Spassky::Server
  class App < Sinatra::Base
    def initialize(device_list=DeviceList.new)
      @device_list = device_list
      super()
    end

    get "/devices/clear" do
      @device_list.clear
    end

    get "/devices/list" do
      @device_list.recently_connected_devices.to_json
    end

    get '/device/connect' do
      redirect idle_url
    end

    def get_device_identifier user_agent
      SingletonDeviceDatabase.instance.device_identifier(user_agent)
    end

    get '/device/idle/:random' do
      device_identifier = get_device_identifier(request.user_agent)

      test_run = TestRun.find_next_to_run_for_user_agent(device_identifier)
      @device_list.update_last_connected(device_identifier)
      if test_run
        redirect_to_run_tests(test_run)
      else
        idle_page
      end
    end

    post '/test_runs' do
      run = TestRun.create({
        :name => params[:name],
        :contents => JSON.parse(params[:contents]),
        :devices => @device_list.recently_connected_devices
      })
      redirect "/test_runs/#{run.id}"
    end

    get '/test_runs/:id' do
      run = TestRun.find(params[:id])
      run.update_connected_devices(@device_list.recently_connected_devices)
      run.result.to_json
    end

    get '/test_runs/:id/run/:random/assert' do
      TestRun.find(params[:id]).save_results_for_user_agent(
        :user_agent => request.user_agent,
        :status => params[:status]
      )
    end

    get '/test_runs/:id/run/:random/:file_name' do
      test_run = TestRun.find(params[:id])
      test_name = params[:file_name]
      HtmlTest.new(test_run.contents, idle_url, 1).get_file(test_name)
    end

    private

    def redirect_to_run_tests(test_run)
      redirect "/test_runs/#{test_run.id}/run/#{RandomStringGenerator.random_string}/#{test_run.name}"
    end

    def idle_url
      "/device/idle/#{RandomStringGenerator.random_string}"
    end

    def idle_page
      "<html><head><meta http-equiv=\"refresh\" content=\"1; url='#{idle_url}'\"></head>" +
      "<body>Idle #{RandomStringGenerator.random_string}</body>" +
      "</html>"
    end
  end
end
