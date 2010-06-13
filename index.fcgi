#!/usr/local/bin/ruby -I /home/kmdsbng/lib/ruby -I /home/kmdsbng/local/lib
ENV['GEM_HOME'] = '/home/kmdsbng/local/lib/ruby/gems'

begin
  require File.dirname(__FILE__) + '/starwars'

  set :run => false, :environment => :production
  Rack::Handler::FastCGI.run Sinatra::Application

rescue Exception => x

  require 'rubygems'
  require 'fcgi'
  require 'pp'

  FCGI.each_cgi {|cgi|
    print cgi.header('text/plain')
    puts "Exception: " + x.message
    puts "Backtrace: \n" + x.backtrace.pretty_inspect
  }
end



