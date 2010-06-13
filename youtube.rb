#!/usr/local/bin/ruby
$:.unshift File.dirname(__FILE__) + '/lib'

require 'rubygems'
require 'sinatra/base'
require File.dirname(__FILE__) + '/patch/patch_all'
require 'content_loader'
require 'cgi'

Entry = Struct.new(:title, :href, :content, :updated)

class YoutubeLoader
  def initialize(content_loader=ContentLoader.new)
    @content_loader = content_loader
  end

  def load_play_list(account)
    url = "http://gdata.youtube.com/feeds/api/users/#{CGI.escapeHTML(account)}/playlists"
    data = @content_loader.load_xml(url)
    entry_nodes = data.xpath(%{//xmlns:entry})
    convert_to_entry(entry_nodes)
  end

  def convert_to_entry(nodes)
    nodes.map {|n|
      Entry.new(n.xpath('./xmlns:title')[0].text,
                n.xpath('./gd:feedLink')[0].attributes['href'].text,
                n.xpath('./xmlns:content[@type="text"]').text,
                Time.parse(n.xpath('./xmlns:updated').text)
      )
    }
  end
end

class MyApp < Sinatra::Base
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
    def show_top_page
      haml :index
    end

  end

  get '' do
    show_top_page
  end

  get '/' do
    show_top_page
  end

  get '/dashboard' do
    @account = params[:account]
    @entries = load_play_list(@account)
    haml :dashboard
  end

  error do
    require 'pp'
    x = env['sinatra.error']
    'Sorry there was a nasty error - ' + "<br>\n" +
    "Exception: " + escape_html(x.inspect) + "<br>\n" +
    "Message: " + escape_html(x.message) + "<br>\n" +
    "Backtrace: \n" + escape_html(x.backtrace.pretty_inspect)
  end
end

if $0 == __FILE__
  MyApp.run! :host => 'localhost', :port => 9090
end



