#!/usr/bin/ruby
#
# A very simple CGI script to receive a Github webhook and
# send to a 'ThoughtWorks Go Server'
#
# Usage:
#     Github Webhooks / Manage webhook
#     Payload URL:
#         http://your-url.example.com/go/pipeline-schedure.rb
#
#     Will send a POST to:
#         http://your-go-server.example.com/go/api/pipelines/#{repo-name}/schedule
#
# This assumes that your pipeline is named after your github repository.
# If both names differ, you may use:
#
#     Payload URL:
#         http://your-url.example.com/go/pipeline-schedure.rb?pipeline={pipeline-name-here}
#
#     Will send a POST to:
#         http://your-go-server.example.com/go/api/pipelines/#{pipeline-name-here}/schedule
#
#
# This script uses a config file named '/etc/go/webhook.json'
# with the following format:
#
#     {
#       "webhook_url": "http://your-url.example.com/",
#       "go_url": "https://your-go-server.example.com",
#       "go_user": "user-here",
#       "go_pass": "password-here"
#     }
#
# You may host this script using any solution you want but, just as a remainder,
# apache with CGI enabled is a very simple and stable option.
#
# Marcus Vinicius Ferreira      ferreira.mv[ at ]gmail.com
# 2014-04
#

require 'cgi'
require 'json'

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

# ENV.keys.sort.each { |k| printf "%-30s = %s </br>\n", k, ENV[k] }

msg = "<html><code>\n\n"

def end_ok(msg)
  puts "Content-type: text/html\n\n"
  puts "#{msg}\n</code></html>"
  exit 0
end

def end_err(msg)
  # http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
  puts "Status: 429 Too Many Requests\n\n"
  puts "Content-type: text/html\n\n"
  puts "#{msg}\n"
  puts "429: Too Many Requests (pipeline already in progress)\n\n"
  puts "</code></html>"
  exit 1
end

if ENV['REQUEST_METHOD'] != 'POST'
    msg << "Method: [#{ENV['REQUEST_METHOD']}]"
    end_ok msg
end

##
## Github sending 'form-www': 'application/vnd.github.v3+form'
##   - post-data is a enconded string:
##     payload=%7B%22zen%22%3A%22Keep+it+logically+awesome.%22%2C%22hook_id%22%3A2061741%7D
##   - cgi.params (after decoded):
##     {"payload"=>["{\"zen\":\"Keep it logically awesome.\",\"hook_id\":2061741}"]}
##   - usage:
##     'payload' is a key to an array
##
# payload = cgi.params['payload'][0]

##
## Github sending 'json': 'application/vnd.github.v3+json'
##   - post-data is a JSON String
##     {"zen":"Keep it logically awesome.","hook_id":2061741}
##   - cgi.params:
##     {"{\"zen\":\"Keep it logically awesome.\",\"hook_id\":2061741}"=>[]}
##   - usage:
##     in the params hash, 'value' is empty while all information
##     is in the key itself.
##
# payload = cgi.params.keys[0]

cgi = CGI.new

if cgi.params.has_key?("payload")
  msg << "post-data: form-www\n"
  payload = cgi.params['payload'][0]
else
  msg << "post-data: json\n"
  payload = cgi.params.keys[0]
end

# msg << "   params: #{cgi.params}\n"
# msg << "  payload: #{payload}\n"

begin
  json = JSON.parse( payload )
rescue
  msg << "Error parsing json...\n"
  msg << "  payload: #{payload}"
  end_ok msg
end

## info, please
config = JSON.parse( File.read('/etc/go/webhook.json') )

if json.has_key?('repository')
  repo   = json['repository']['name']
  url_go = "#{config['go_url']}/go/api/pipelines/#{repo}/schedule"
  msg << "     repo: #{repo}\n"
elsif json.has_key?('hook_id')
  msg << "  hook_id: #{json['hook_id']}\n"
  end_ok msg
else
  msg << "What json is that?\n"
  msg << "  wtf?: #{payload}"
  end_ok msg
end

## extra: sometimes 'repository name' is not the same as
##        'pipeline' name. An optional parameter takes
##        precedence.
if cgi.params.has_key?('pipeline')
  pipeline = cgi.params['pipeline'][0]
  url_go = "#{config['go_url']}/go/api/pipelines/#{pipeline}/schedule"
  msg << " pipeline: #{pipeline}\n"
end

## builds only to master branch, please!
master_branch = "refs/heads/#{json['repository']['master_branch']}"
if json['ref'] != master_branch
  msg << "  commit to: #{json['ref']}\n"
  msg << "  I will ignore this. Builds only apply to 'master', please.\n"
  end_ok msg
end

## debug(?)
# puts "\n\ncgi</br>"
# pp cgi
# puts "\n\n"

## forward now...
res = `curl -s -k -u '#{config['go_user']}:#{config['go_pass']}' -d '' #{url_go}`
msg << "   result: #{res}\n"

end_err msg if res =~ /Failed/i
end_ok  msg

# vim:ft=ruby:

