#!/usr/bin/env ruby

# Extract user_agent and device id from wurfl.xml (http://wurfl.sourceforge.net/)
#
# To run:
#     wurfl-user-agents.rb | sort | uniq > user-agents.csv
#
# Marcus Vinicius Ferreira
# 2010/08
#

require "rubygems"
require "nokogiri"


xml = Nokogiri::XML.parse(File.open('wurfl.xml'))

xml.xpath('/wurfl/devices').children.each do |c|
    printf "'%s','%s'\n", c['id'], c['user_agent']
  # printf "'%s','%s','%s'\n", c['fall_back'], c['id'], c['user_agent']
end

# vim:ft=ruby:

