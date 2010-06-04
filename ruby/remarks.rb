#
# http://www.caliban.org/ruby/rubyguide.shtml
#

### boolean
###
if foo.empty?       if foo == ""
  ...                 ...
end                 end

if foo.zero?        if foo == 0
  ...                 ...
end                 end

true    false
----    -----
0       undef
""      nil
''

### initialisation
###

foo = ""
foo = String.new

foo = []
foo = Array.new

foo = {}
foo = Hash.new

### Binding
###
    - || && : higher precedence: inside arguments of same command
      puts nil || "foo"   # parses to: puts( nil || "foo" )  => prints "foo"

    - or and : lower precedence: between commands
      puts nil or "foo"   # parses to: puts( nil ) || "foo"  => prints nil
      puts nil or error "Cannot put..."





### exceptions
###
begin
    file = open( fname, "w")
    # do stuff here
rescue
    fname = '/tmp/1.txt'
    retry
ensure
    file.close # finalizing code
end


### warnings
###
def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end

Since this method takes a block as its parameter, you can now pass it arbitrary chunks of code to execute without warnings:

silently { require 'net/https' }


### optparse
###


opt = {}
OptionParser.new do |opts|
    opts.banner    = "Usage: #{$0} [-n] -d dir_name\n\n"
    opts.separator ""
    opts.separator "    Limpa arquivos criados há menos de 5 minutos\n\n"
    opts.separator ""

    opts.on("-d", "--dir dir_name", "dir name") do |op|
        opt[:dir] = op
    end
    opts.on("-n", "--no" , "no removing. Test only") do |op|
        opt[:no] = op
    end
end.parse!

dir_path = opt[:dir]
# usage() unless opt["d"]
# usage() unless File.directory?(dir_path)
opt.each do |k,v|
    puts "Option: #{k} : #{v}"
end
p opt
p ARGV
exit

###
###
###

# == Synopsis
#    This is a sample description of the application.
#    Blah blah blah.
#
#
# == Usage
#    ruby_cl_skeleton [options] source_file
#
#    For help use: ruby_cl_skeleton -h
#
# == Options
#    -h, --help          Displays help message
#    -v, --version       Display the version, then exit
#    -q, --quiet         Output as little as possible, overrides verbose
#    -V, --verbose       Verbose output
#    TO DO - add additional options
#
# == Examples
#    This command does blah blah blah.
#       ruby_cl_skeleton foo.txt
#
#    Other examples:
#      ruby_cl_skeleton -q bar.doc
#      ruby_cl_skeleton --verbose foo.html
#
## == Author
#    YourName
#
# == Copyright
#    Copyright (c) 2007 YourName. Licensed under the MIT License:
#    http://www.opensource.org/licenses/mit-license.php


# TO DO - replace all ruby_cl_skeleton with your app name
# TO DO - replace all YourName with your actual name
# TO DO - update Synopsis, Examples, etc
# TO DO - change license if necessary

