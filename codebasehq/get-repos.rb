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


# GET /projects
# Ref:
#     Object properties
#     http://support.codebasehq.com/kb/projects
#
res = codebasehq_api_get( '/projects' )

# convert to hash
parser = Nori.new
xml_hash = parser.parse(res)

# all users
all_projects = []
xml_hash['projects'].each do |p|

  all_projects << p['permalink']

end


# repositories
all_projects.each do |project|

  # All repositories
  # Ref:
  #   http://support.codebasehq.com/kb/repositories
  #
  res = codebasehq_api_get("/#{project}/repositories")
  xml_repo = parser.parse(res)

  xml_repo['repositories'].each do |repo|

    printf "%-35s  # %s: [%s]\n", "#{project}/#{repo['permalink']}", repo['name'], repo['description']

  end

end

# vim:ft=ruby:

