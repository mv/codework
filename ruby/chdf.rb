#!/usr/bin/env ruby
#
#

require "find"


# no arguments: uses current dir
ARGV[0] ||= '.'


# Executables:
#     bat exe: valid in cygwin env
suffixlist = {
  '.bat' => 1, '.exe' => 1, '.sh'  => 1, '.ksh' => 1,
  '.pl'  => 1, '.py'  => 1, '.rb'  => 1
}

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

  end # find

end # arg


