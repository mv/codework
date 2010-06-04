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
require 'rdoc/usage'

require 'find'
require 'optparse'

dir_path = ""
min_time = 5*60
opt = { :no => false, :v => false }

opts = OptionParser.new
opts.on("-d", "--dir dirname") do |dir|
    dir_path = dir
end
opts.on("-m", "--min minutes") do |min|
    min_time = min.to_i*60
end
opts.on("-n", "--no"         ) { opt[:no] = true }
opts.on("-v", "--verbose"    ) { opt[:v]  = true }

begin
    $VERBOSE = nil ; opts.parse!
rescue
    RDoc::usage( 1, 'usage' )
end

unless File.directory?(dir_path)
    puts "\nInvalid dir #{dir_path}\n"
    RDoc::usage( 2, 'usage' )
end

$VERBOSE = true
now = Time.now
Find.find(dir_path) do |file|
    next if file =~ /^\.\.?$/
    next if File.directory?(file)

    mtime = File.lstat(file).mtime
    age = now - mtime
    if( age >= min_time )
        printf "Age: %02d min - %s %s\n", age/60, mtime.strftime("%Y-%m-%d %H:%M"), file if opt[:v]
        File.unlink(file) unless opt[:no]
    end
end

