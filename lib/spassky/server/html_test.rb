module Spassky::Server
  class HtmlTest
    def initialize(contents, url, seconds)
      @contents = contents
      @url = url
      @seconds = seconds
    end

    def get_file(name)
      file_contents = @contents[name]
      add_helpers_to_html file_contents
    end

    private

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
