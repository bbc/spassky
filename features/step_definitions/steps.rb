Given /^a connected mobile device$/ do
  visit "/device/connect"
end

When /^I run "([^"]*)" with the server host$/ do |command_line|
  require 'uri'
  uri = URI.parse(current_url)  
  run_simple(unescape(command_line.gsub('<host>', "http://#{uri.host}:#{uri.port}")), false)
end

Then /^it should wait for a test to run$/ do
  urls = [page.current_url]
  sleep 2
  urls << page.current_url
  sleep 2
  urls << page.current_url
  urls.uniq.size.should eq(3), "expected 3 different urls, got:\n" + urls.join("\n")
end