module Spassky::Server
  class TestSuiteContainer
    def initialize(contents, next_url_to_redirect_to, assert_post_back_url, seconds)
      @contents = contents
      @next_url_to_redirect_to = next_url_to_redirect_to
      @assert_post_back_url = assert_post_back_url
      @seconds = seconds
    end

    def get_file(name)
      file_contents = @contents[name]
      add_helpers_to_html file_contents
    end

    private

    def add_helpers_to_html html
      html.gsub('</head>', assert_js_script + '</head>')
    end

    def assert_js_script
      assert_js = File.read(File.join(File.dirname(__FILE__), 'assert.js'))
      assert_js.gsub!("{ASSERT_POST_BACK_URL}", @assert_post_back_url)
      assert_js.gsub!("{IDLE_URL}", @next_url_to_redirect_to)
      "<script type=\"text/javascript\">#{assert_js}</script>"
    end
  end
end
