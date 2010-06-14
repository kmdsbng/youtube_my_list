#!/usr/local/bin/ruby
$KCODE = 'u'
$:.unshift File.dirname(__FILE__) + '/lib'

require 'rubygems'
require 'sinatra/base'
require File.dirname(__FILE__) + '/patch/patch_all'
require 'ext'
require 'youtube_loader'
require 'cgi'

#Haml::Template.options[:escape_html] = true

class MyApp < Sinatra::Base
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
    def show_top_page
      haml :index
    end

    def u(str)
      CGI.escape(str)
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
    @entries = YoutubeLoader.new.load_playlists(@account)
    haml :dashboard
  end

  get '/playlist' do
    @account = params[:account]
    @playlist_id = params[:playlist_id]
    @title, @entries = YoutubeLoader.new.load_playlist(@playlist_id)
    haml :playlist
  end

  get '/play' do
    @url = params[:url]
    @title = '再生'
    haml :play
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



