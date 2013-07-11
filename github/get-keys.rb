#!/usr/bin/env ruby
#
# CodebaseHQ API
#
# Get list of users
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2013-07
#

@username = ENV['GITHUB_USER']
@password = ENV['GITHUB_PASS']
@org      = ENV['GITHUB_ORG']

# puts "# username: #{@username}"
# puts "# apikey:   #{@apikey}"
# puts "# domain:   #{@domain}"

require 'uri'
require 'net/http'
require 'net/https'
require 'json'


def github_api_get(url)

  url = URI.parse("https://api.github.com/#{url}")

  # using https
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  # Ref:
  #     Authentication
  #     http://developer.github.com/v3/#authentication
  #
  req = Net::HTTP::Get.new(url.path)
  req.basic_auth("#{@username}", "#{@password}" )

  # response is a JSON string
  response = http.start { |http| http.request(req) }.body

  return JSON.parse(response)

end


# All users from an Organization
# Ref:
#     http://developer.github.com/v3/orgs/members/
#

members = github_api_get("orgs/#{@org}/members")

members.each do |member|

  user = github_api_get("users/#{member['login']}")
  keys = github_api_get("users/#{member['login']}/keys")

  keys.each do |key|
    printf "%-15s: %s %s\n", user['login'], key['key'], user['login']
  end

end


# vim:ft=ruby:

