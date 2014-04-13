#!/usr/bin/ruby

require 'rubygems'
require 'json'

if ARGV.size != 1
  puts "Usage: #{$0} <file>"
  exit 1
end

def escape(string)
  parse = JSON.parse({ 'json' => string }.to_json)
  parse['json']
end

File.open(ARGV[0]).each do |line|
  puts "#{escape(line).inspect} ,"
end

# Add a blank to fix last comma
puts '"\n"'

# vim:ft=ruby:

