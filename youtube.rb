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
  set :haml, :escape_html => true

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
    def show_top_page
      haml :index
    end

    def u(str)
      CGI.escape(str.to_s)
    end

    def redirect_to_next_playitem
      next_position = calc_next_position(@position, @playlist_video.total, @reverse)
      redirect "?account=#{u @account}&playlist_id=#{u @playlist_id}&position=#{u next_position}&reverse=#{@reverse ? 1 : 0}", 302
    end

    def redirect_to_next_playitem_search
      next_position = calc_next_position(@position, @search_video.total, @reverse)
      redirect "?account=#{u @account}&q=#{u @q}&position=#{u next_position}&reverse=#{@reverse ? 1 : 0}", 302
    end

    def calc_next_position(position, total, reverse)
      if reverse
        if (posision - 1 < 1)
          total
        else
          [position - 1, total].min
        end
      else
        if position + 1 > total
          1
        else
          [position + 1, 1].max
        end
      end
    end

  end

  get '/*.css' do |path|
    content_type 'text/css'
    sass path.to_sym, :sass => {:load_paths => [options.views]}
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

  get '/favorites' do
    @account = params[:account]
    @url = params[:url]
    loader = YoutubeLoader.new
    @favorites = @url ? loader.load_favorites_by_url(@url) : loader.load_favorites(@account)
    haml :favorites
  end

  get '/playlist' do
    @account = params[:account]
    @playlist_id = params[:playlist_id]
    @url = params[:url]
    loader = YoutubeLoader.new
    @playlist = @url ? loader.load_playlist_by_url(@url) : loader.load_playlist(@playlist_id)
    @playlist_id = @playlist.playlist_id
    haml :playlist
  end

  get '/search_top' do
    @account = params[:account]
    @videos = VideoListData.new
    @videos.entries = []
    haml :search
  end

  get '/search' do
    @account = params[:account]
    @q = params[:q]
    @url = params[:url]
    loader = YoutubeLoader.new
    @videos = @url ? loader.search_videos_by_url(@url) : loader.search_videos(@q)
    haml :search
  end

  get '/play' do
    @account = params[:account]
    @url = params[:url]
    @title = '再生'
    haml :play
  end

  get '/play_playlist' do
    @account = params[:account]
    @playlist_id = params[:playlist_id]
    @position = params[:position].to_i
    @reverse = params[:reverse].to_i == 1
    loader = YoutubeLoader.new
    @playlist_video = loader.load_playlist_video(@playlist_id, @position)
    @title = '再生'
    page = ((@position - 1) / 25)
    @playlist_url = YoutubeLoader.new.get_playlist_url(@playlist_id) + "?start-index=#{page * 25 + 1}&max-results=25"
    if @playlist_video.href.to_s.empty?
      redirect_to_next_playitem
    else
      haml :play_playlist
    end
  end

  get '/play_search' do
    @account = params[:account]
    @q = params[:q]
    @position = params[:position].to_i
    @reverse = params[:reverse].to_i == 1
    loader = YoutubeLoader.new
    @search_video = loader.load_search_video(@q, @position)
    @title = '再生'
    page = ((@position - 1) / 25)
    @search_url = YoutubeLoader.new.get_search_url(@q) + "&start-index=#{page * 25 + 1}&max-results=25"
    if @search_video.href.to_s.empty?
      redirect_to_next_playitem_search
    else
      haml :play_search
    end
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



