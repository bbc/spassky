Given /^a connected mobile device$/ do
  visit "/device/connect"
end

Then /^it should wait for a test to run$/ do
  urls = [page.current_url]
  sleep 2
  urls << page.current_url
  sleep 2
  urls << page.current_url
  urls.uniq.size.should eq(3), "expected 3 different urls, got:\n" + urls.join("\n")
end