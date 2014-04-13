#!/usr/bin/ruby

require 'cgi'
require 'pp'

##
## Remember:
##   - CGI is any program/script executed by the webserver
##   - webserver will pass information in 2 ways:
##       - using ENVIRONMENT variables
##       - using STDIN for POST/PUT methods, encoded
##   - 'CGI' is a module that will handle both inputs by itself
##   - 'CGI' will decode all data by itself
##   - 'cgi.params' is a Hash with all inputs combined
##


cgi = CGI.new

puts "Content-type: text/html\n\n"

puts "<html><pre>"
puts "Environment"
puts "-----------"

ENV.keys.sort.each { |k| printf "%-20s = %s\n", k, ENV[k] }

# force(?)
ENV['QUERY_STRING'].split(/&/).each do |qs|
  k,v = qs.split(/=/)
# cgi.params[k] = v
  cgi.params[k] = [] << v
end

puts "\n\ncgi\n---\n"
pp cgi

puts "\ncgi.params\n----------\n"
puts cgi.params

puts "\ncgi.params keys\n---------------\n"
cgi.params.keys.sort.each { |k| puts "  #{k} = #{cgi.params[k]}" }

puts "\ncgi.keys\n---------------\n"
cgi.keys.sort.each { |k| puts "  #{k} = #{cgi.params[k]}" }

puts "\n</pre></html>\n\n"

puts "print\n"
puts cgi.print, "\n"

# vim:ft=ruby:
