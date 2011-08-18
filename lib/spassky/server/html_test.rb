module Spassky::Server
  class HtmlTest
    def initialize(contents, url, seconds)
      @contents = contents
      @meta_refresh_tag = "<meta http-equiv=\"refresh\" content=\"#{seconds}; url='#{url}'\">"
    end

    def get_file(name)
      file_contents = @contents[name]
      unless file_contents
        html_file = @contents.keys.find {|key| key.end_with?(".html")}
        file_contents = @contents[html_file]
      end
      file_contents.gsub('</head>', assert_js_script_tag + @meta_refresh_tag + '</head>')
    end

    private

    def assert_js_script_tag
      "<script type=\"text/javascript\">#{assert_js_script}</script>"
    end

    def assert_js_script
      File.read(File.join(File.dirname(__FILE__), 'assert.js'))
    end
  end
end
