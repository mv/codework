#!/usr/bin/ruby
#
# Encoding an arbitrary file to be used inside
# a CloudFormation Json template.
#
# Marcus Vinicius Ferreira
# 2014-03
#

require 'rubygems'
require 'json'

if ARGV.size != 1
  puts ""
  puts "Usage: #{$0} <file>"
  puts ""
  puts "    Encode a file to be used in a CF template."
  puts ""
  exit 1
end

def escape(value)
  j = { 'key' => value }.to_json  # json, escaped
  h = JSON.parse(j)               # hash, please
  h['key']                        # just the value, please
end

# begin
puts ''
puts '    "content" : { "Fn::Join" : ["", ['

# main stuff
File.open(ARGV[0]).each { |line| puts "        #{escape(line).inspect} ," }

# end
puts '        "\n"'
puts '    ]]}'
puts ''

# vim:ft=ruby:

