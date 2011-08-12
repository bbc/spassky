module Spassky::Server
  class HtmlTest
    def initialize(original_html)
      @html = original_html
      @meta_refresh_tag = ""
    end
    
    def add_meta_refresh_tag(url, seconds)
      @meta_refresh_tag = "<meta http-equiv=\"refresh\" content=\"#{seconds}; url='#{url}'\">"
    end
    
    def html
      @html.gsub('</head>', assert_js_script_tag + @meta_refresh_tag + '</head>')
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