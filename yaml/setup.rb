#
# configs
# Ref:
#     http://rhnh.net/2011/01/31/yaml-tutorial
#
# 2014-05

require 'yaml'

###
### reading
###

dir = File.expand_path(File.dirname(__FILE__))
str = File.open("#{dir}/setup.yml").read

y = YAML.load( str )

puts y['production']['agent']['opts']
puts y['production']['server']['opts']['w']
puts y['production']['server']['opts']['pluginpath']

puts y['production']['agent']['output']
puts y['production']['server']['output']


###
### writing
###

node = {}

node['region'] = 'us-east-1'

node['az'] = {}
node['az']['a'] = [ 'a01', 'a02', 'a03' ]
node['az']['b'] = [ 'b01', 'b02', 'b03' ]

puts YAML.dump( node )
puts node.to_yaml


