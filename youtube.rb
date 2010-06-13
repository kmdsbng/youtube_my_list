#!/usr/local/bin/ruby -I /home/kmdsbng/lib/ruby -I /home/kmdsbng/local/lib
ENV['GEM_HOME'] = '/home/kmdsbng/local/lib/ruby/gems'
$:.unshift File.dirname(__FILE__) + '/lib'
  
require '/home/kmdsbng/local/lib/rubygems'
require 'sinatra/base'
require File.dirname(__FILE__) + '/patch/patch_all'
require 'starwars_formatter'

class MyApp < Sinatra::Base
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

  get '' do
    haml :index
  end

  get '/' do
    haml :index
  end

  get '/' do
    haml :index
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



