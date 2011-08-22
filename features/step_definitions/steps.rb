require 'uri'

Given /^a connected mobile device "([^"]*)"$/ do |user_agent|
  register_driver_with_user_agent user_agent
  using_session(user_agent) do
    visit '/device/connect'
    @uri = URI.parse(current_url)
  end
  @last_user_agent = user_agent
end

Given /^a file named "([^"]*)" with ([^\s]*) in it$/ do |file_name, fixture_name|
  fixture_path = File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "fixtures", fixture_name))
  fixture_content = File.read(fixture_path)
  write_file(file_name, fixture_content)
end

Given /^a Wireless Universal Resource FiLe$/ do
end

When /^I run "([^"]*)" with the server host$/ do |command_line|
  run_simple(unescape(command_line.gsub('<host>', "http://#{@uri.host}:#{@uri.port}")), false)
end

Then /^it should wait for a test to run$/ do
  using_session(@last_user_agent) do
    urls = [page.current_url]
    sleep 2
    urls << page.current_url
    sleep 2
    urls << page.current_url
    urls.uniq.size.should eq(3), "expected 3 different urls, got:\n" + urls.join("\n")
  end
end

Then /^the word "Idle" should appear on the device$/ do
  using_session(@last_user_agent) do
    page.html.should include("Idle")
  end
end

When /^the device disconnects$/ do
  using_session(@last_user_agent) do
    visit "/device/disconnect"
  end
end

Given /^I run spassky\-server$/ do
  @spassky_server_process = ChildProcess.build('./bin/spassky-server')
  @spassky_server_process.start
end

Then /^it should not crash$/ do
  @spassky_server_process.should_not be_crashed
  @spassky_server_process.stop
end
