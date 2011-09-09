module Spassky::Server
  class HtmlTest
    def initialize(contents, url, seconds)
      @contents = contents
      @url = url
      @seconds = seconds
    end

    def get_file(name)
      file_contents = @contents[name]
      if file_contents.nil?
        file_contents = get_test_file_contents
      end
      add_helpers_to_html file_contents
    end

    private

    def get_test_file_contents
      html_file = @contents.keys.find {|key| key.end_with?(".html")}
      file_contents = @contents[html_file]
    end

    def add_helpers_to_html html
      html.gsub('</head>', assert_js_script + meta_refresh_tag + '</head>')
    end

    def assert_js_script
      assert_js = File.read(File.join(File.dirname(__FILE__), 'assert.js'))
      "<script type=\"text/javascript\">#{assert_js}</script>"
    end

    def meta_refresh_tag
      "<meta http-equiv=\"refresh\" content=\"#{@seconds}; url='#{@url}'\">"
    end
  end
end
