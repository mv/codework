require 'pp'
require 'awesome_print'
 
require 'aws-sdk'
 
AWS.config(
  :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :region => 'sa-east-1'
)
 
