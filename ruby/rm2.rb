#!/usr/bin/env ruby
#
# == Usage
#
#     rm-cache-files.rb [-n] [-min n] -d dir_name
#
#     Clean-up files older than 'n' minutes
#
#     -h, --help          Displays help message
#     -d, --dir dirname   Directory to clean
#     -m, --min n         Files older than 'n' minutes. Default 5 min.
#     -n, --no            No cleaning: test only.
#     -v, --verbose       Verbose output
#
# == Author
# Marcus Vinicius Ferreira              ferreira.mv[ at ]gmail.com
# 2010/06
#

require 'find'
require 'optiflag'

module Opt extend OptiFlagSet
  flag "min_time"
  flag "dir_path" do
    puts "\nInvalid dir #{dir_path}\n" unless File.directory?(dir_path)
  end
  optional_switch_flag "no"
  optional_switch_flag "verbose"

  usage_flag "h","help","?"
  and_process!
end

min_time = Opt.flags.min_time || 5*60

now = Time.now
Find.find(Opt.flags.dir_path) do |file|
    next if File.directory?(file)

    mtime = File.lstat(file).mtime
    age = now - mtime
    if( age >= min_time )
        printf "Age: %02d min - %s %s\n", age/60, mtime.strftime("%Y-%m-%d %H:%M"), file if Opt.flags.verbose?
        File.unlink(file) unless Opt.flags.no?
    end
end

