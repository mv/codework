#!/usr/bin/env ruby
#
#

require "find"


# no arguments: uses current dir
ARGV[0] ||= '.'


# for each argument
ARGV.each do |arg|

  # find all types
  Find.find( arg ) do |f|
    puts "%10s : %s" % [File.ftype(f), f]
  end

end # arg



