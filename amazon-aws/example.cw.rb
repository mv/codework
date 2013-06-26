require 'aws-sdk'

AWS.config({
  :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :region            => 'sa-east-1'
})

cw = AWS::CloudWatch.new

# cw.client.list_metrics

a = cw.client.get_metric_statistics(
  namespace: 'AWS/EC2',
  metric_name: 'CPUUtilization',
  statistics: ['Average'],
  dimensions: [ { :name => 'DBInstanceIdentifier', :value => 'dinda-01'}],
  start_time: (Time.now() - 120).iso8601,
  end_time:   (Time.now() -  60).iso8601,
  period: 60
)

# a =
#   {
#     :datapoints=>[
#         { :timestamp=>2013-06-16 22:24:00 UTC, :unit=>"Percent", :average=>0.7 }
#     ],
#     :response_metadata=>{:request_id=>"d5114b92-d6d3-11e2-8230-5903dc3b36fb"}
#     :label=>"CPUUtilization",
#   }
# a[:datapoints][0][:average]


b = cw.client.get_metric_statistics(
  :namespace   => 'AWS/EC2',
  :metric_name => 'CPUUtilization',
  :statistics  => ['Average'],
  :dimensions  => [{ :name => 'InstanceId', :value => 'i-1e112703'}],
  :start_time  => (Time.now().gmtime - 120).iso8601,
  :end_time    => (Time.now().gmtime -  60).iso8601,
  :period      => 60
)[:datapoints][0]

# 1.9.3 (main)> b
# => {
#     :timestamp => 2013-06-16 22:56:00 UTC,
#          :unit => "Percent",
#       :average => 0.79
# }

b['Average'.downcase.to_sym]
b[:unit]

###
### Put back to localtime:
###

b[:timestamp]
b[:timestamp].to_time

###
### Back 2 back
###
b[:timestamp].to_time.utc
b[:timestamp].to_time.localtime


#       options[:namespace] = namespace
#       options[:metric_name] = metric_name
#       options[:dimensions] = dimensions unless dimensions.empty?
#       options[:start_time] = start.respond_to?(:iso8601) ? start.iso8601 : start
#       options[:end_time] = stop.respond_to?(:iso8601) ? stop.iso8601 : stop
#       options[:period] ||= 60

#       resp = client.get_metric_statistics(options)


options = {
  :start_time  => (Time.now().gmtime - 120).iso8601,
  :end_time    => (Time.now().gmtime -  60).iso8601,
  :period      => 60
}

c = cw.client.get_metric_statistics(
  :namespace   => 'AWS/EC2',
  :metric_name => 'CPUUtilization',
  :statistics  => ['Average'],
  :dimensions  => [{ :name => 'InstanceId', :value => 'i-586cec46'}],
  :start_time  => (Time.now().gmtime - 120).iso8601,
  :end_time    => (Time.now().gmtime -  60).iso8601,
  :period      => 60
)[:datapoints][0]


#       options[:namespace] = namespace
#       options[:metric_name] = metric_name
#       options[:dimensions] = dimensions unless dimensions.empty?
#       options[:start_time] = start.respond_to?(:iso8601) ? start.iso8601 : start
#       options[:end_time] = stop.respond_to?(:iso8601) ? stop.iso8601 : stop
#       options[:period] ||= 60

#       resp = client.get_metric_statistics(options)

metrics = [
    'BinLogDiskUsage',
    'CPUUtilization',
    'DatabaseConnections',
    'DiskQueueDepth',
    'FreeStorageSpace',
    'FreeableMemory',
    'ReadIOPS',
    'ReadLatency',
    'ReadThroughput',
    'SwapUsage',
    'WriteIOPS',
    'WriteLatency',
    'WriteThroughput'
]

metrics.each do |m|
    r = cw.client.get_metric_statistics(
      :namespace   => 'AWS/RDS',
      :metric_name => m ,
      :statistics  => [ 'Average' ],
      :dimensions  => [{ :name => 'DBInstanceIdentifier', :value => 'dinda-01'}],
      :start_time  => (Time.now().gmtime - 120).iso8601,
      :end_time    => (Time.now().gmtime -  60).iso8601,
      :period      => 60
    )[:datapoints][0]
    puts "#{m}  #{r[:average]}"
    puts "#{r[:timestamp].to_time.iso8601.gsub(/T/, ' ')}   #{r[:average]}   #{r[:unit]}"
end

# vim:ft=ruby:

