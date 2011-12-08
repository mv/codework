#!/usr/bin/env ruby
#
# md5r.rb:
#     md5 recursively
#
#     https://github.com/remvee/exifr/
#     https://github.com/amberbit/xmp/
#
# EXIFR::JPEG.new('/Users/marcus/Pictures/familia/SAMSUNG/DCIM/101PHOTO/SAM_1311.JPG').date_time.strftime('%Y-%m-%d %X %Z')
# EXIFR::JPEG.new('/Users/marcus/Pictures/familia/SAMSUNG/DCIM/101PHOTO/SAM_1734.MP4').date_time.strftime('%Y-%m-%d %X %Z')


require "find"
require "digest/md5"

require "rubygems"
require "exifr"

# no arguments: uses current dir
ARGV[0] ||= '.'

# for each argument
ARGV.each do |arg|

  # find all types
  Find.find( arg ) do |f|

    next if File.ftype(f) != 'file'

    digest = Digest::MD5.hexdigest(File.read(f))

    if File.extname(f) =~ /jpe?g/i
        # dt = EXIFR::JPEG.new(f).date_time.strftime('%Y-%m-%d')
        if dt = EXIFR::JPEG.new(f).date_time
           dt = dt.strftime('%Y-%m-%d')
        else
          dt = '=' * 10
        end
    else
        dt = '-' * 10
    end
    puts "%s %s %s %-30s %s" % [digest, digest[0..6], dt, File.basename(f), f]

  end # find

end # arg

