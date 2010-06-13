require 'rubygems'
require 'nkf'
require 'open-uri'
require 'nokogiri'
require 'date'
require 'json'
require 'pp'

class ContentLoader
  class << self
    def download_content(url)
      open(url) {|io|
        io.read
      }
    end

    def load_nokogiri_content(url)
      html = NKF.nkf('-w8', download_content(url))
      Nokogiri::HTML(html, url, 'UTF-8')
    end

    def load_nokogiri_xml(url)
      html = NKF.nkf('-w8', download_content(url))
      Nokogiri::XML(html, url, 'UTF-8')
    end
  end

end


