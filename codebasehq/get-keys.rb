#!/usr/bin/env ruby
#
# CodebaseHQ API
#
# Get list of users
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2013-07
#

@username = ENV['CODEBASEHQ_USER']
@apikey   = ENV['CODEBASEHQ_APIKEY']
@domain   = ENV['CODEBASEHQ_DOMAIN']

# puts "# username: #{@username}"
# puts "# apikey:   #{@apikey}"
# puts "# domain:   #{@domain}"

require 'uri'
require 'net/http'
require 'net/https'
require 'nokogiri'
require 'nori'


def codebasehq_api_get(url)

  url = URI.parse("https://api3.codebasehq.com/#{url}")

  # using https
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  # Ref:
  #     Authenticating & Accessing the API
  #     http://support.codebasehq.com/kb
  #
  req = Net::HTTP::Get.new(url.path)
  req.basic_auth("#{@domain}/#{@username}" , "#{@apikey}" )
  req.add_field('Content-type' , 'application/xml')
  req.add_field('Accept'       , 'application/xml')

  # response is a XML string
  response = http.start { |http| http.request(req) }.body
# return response

end


# GET /users
# Ref:
#     Object properties
#     http://support.codebasehq.com/kb/user-management
#
res = codebasehq_api_get( '/users' )

# convert to hash
parser = Nori.new
xml_hash = parser.parse(res)

# all users
all_users = []
xml_hash['users'].each do |u|

  next if u['company'] != 'Eden'
  next if u['username'].nil?

  all_users << u['username']

end


# ssh-keys
all_users.sort.each do |username|

  next if (username.nil? or username.empty?)
# puts "Username: #{username} - #{username.nil?}"

  # XML for public keys
  # Ref:
  #   http://support.codebasehq.com/kb/public-keys
  #
  res = codebasehq_api_get("/users/#{username.gsub( /[.]/, '%2E')}/public_keys")

  # Object properties
  #   http://support.codebasehq.com/kb/public-keys
  #
  xml_keys = Nokogiri::XML.parse(res)
  all_keys = xml_keys.xpath("public-key-joins/public-key-join/key").map { |key| key.text }

  # all keys using an array
# all_keys.each do |key|
#   printf "%s: %s\n", username, key
# end

  # just the first key
  printf "%-20s: %s %s@baby\n", username, all_keys[0], username

end

# vim:ft=ruby:

