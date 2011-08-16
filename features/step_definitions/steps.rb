require 'uri'

Given /^a connected mobile device "([^"]*)"$/ do |user_agent|
  register_driver_with_user_agent user_agent
  using_session(user_agent) do
    visit '/device/connect'
    @uri = URI.parse(current_url)
  end
  @last_user_agent = user_agent
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

When /^the device disconnects$/ do
  using_session(@last_user_agent) do
    visit "/device/disconnect"
  end
end