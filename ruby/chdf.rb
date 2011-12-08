#!/usr/bin/env ruby
#
#

require "find"


# no arguments: uses current dir
ARGV[0] ||= '.'


# Executables:
#     bat exe: valid in cygwin env
suffixlist = Hash[ %w/bat exe sh ksh pl py rb/.map {|x| [x, 1]} ]

# for each argument
ARGV.each do |arg|

  # find all types
  Find.find( arg ) do |f|

    ftype = File.ftype(f)
    if ftype == 'directory'
      File.chmod( 0775, f)
    elsif ftype == 'file'
      File.chmod( 0664, f)
      File.chmod( 0775, f) if suffixlist[ File.extname(f) ]
    end


  end

end # arg

