#!/usr/local/bin/ruby

require File.join(File.dirname(__FILE__), 'environment')

begin
  require File.dirname(__FILE__) + '/youtube'
  MyApp.set(:run => false, :environment => :production)
  Rack::Handler::CGI.run MyApp

rescue Exception => x
  require 'cgi'
  require 'pp'
  cgi = CGI.new
  print cgi.header('text/plain')
  puts "Exception: " + x.message
  puts "Backtrace: \n" + x.backtrace.pretty_inspect
end



