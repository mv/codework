
require 'aws-sdk'
require 'pp'
require 'awesome_print'

AWS.config(
  :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :region => 'sa-east-1'
)

r53 = AWS::Route53.new

resp = r53.client.list_hosted_zones

resp[:hosted_zones].each do |x|
#   puts x.class
#   puts x
end

resp[:hosted_zones].select { |x| puts x[:id] + ' ' + x[:name] }

# http://stackoverflow.com/questions/2244915/how-do-i-search-within-an-array-of-hashes-by-hash-values-in-ruby
puts  resp[:hosted_zones].select { |x| x[:id] if x[:name] == 'edenbr-prd.com.' }

puts 'equal'
      resp[:hosted_zones].select { |x| puts x[:id] if x[:name] == 'edenbr-prd.com.' }

# http://stackoverflow.com/questions/3419050/ruby-select-a-hash-from-inside-an-array
puts 'regex'
      resp[:hosted_zones].find { |x| puts x[:id] if x[:name] =~ /edenbr-prd.com/ }

puts 'regex variable'
      domain='edenbr-prd'
      resp[:hosted_zones].find { |x| puts x[:id] if x[:name] =~ /#{domain}/ }



