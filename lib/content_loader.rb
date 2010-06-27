require 'rubygems'
require 'nkf'
require 'open-uri'
require 'nokogiri'
require 'date'
require 'json'
require 'pp'

class ContentLoader
  def download_content(url)
    begin
      open(url) {|io|
        io.read
      }
    rescue Exception => x
      x2 = RuntimeError.new("download url failed. url: #{url} (#{x.message})")
      x2.set_backtrace(x.backtrace)
      raise x2
    end
  end

  def load_html(url)
    html = NKF.nkf('-w8', download_content(url))
    Nokogiri::HTML(html, url, 'UTF-8')
  end

  def load_xml(url)
    html = NKF.nkf('-w8', download_content(url))
    Nokogiri::XML(html, url, 'UTF-8')
  end

end


