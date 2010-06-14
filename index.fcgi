#!/usr/local/bin/ruby

require File.join(File.dirname(__FILE__), 'environment')

begin
  require File.dirname(__FILE__) + '/youtube'
  MyApp.set(:run => false, :environment => :production)
  Rack::Handler::FastCGI.run MyApp

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



