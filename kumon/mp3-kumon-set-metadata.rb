#!/usr/bin/env ruby
# vim:ft=ruby:
#
# Kumon: set mp3 metadata information
#
# ferreira.mv@gmail.combination
# 2016-02

require 'mp3info'
require 'pp'

# Directory name is CD title
@album = Dir.pwd.split('/').last

# tag info
@artist = 'Kumon Nihongo'

# header info
@date   = '2012'
@genre  = 'Language'
@language = 'Japanese/Portuguese'
@description = 'Metodo Kumon - Nihongo'
@publisher   = 'Kumon Instituto de Educacao Ltda'
@copyright   = 'Kumon Institute of Education JP KIE 2012 BR'

# track names and info
Dir.glob( "#{Dir.pwd}/*.mp3" ).sort.each do |file|

  puts file

  # info
  Mp3Info.open( file ) do |mp3|

    @title = File.basename( file , '.*' )

    # set new info
    mp3.tag.title  = @title
    mp3.tag.album  = @album
    mp3.tag.artist = @artist

#   mp3.header.copyright = @copyright

    # show new info
#   pp mp3
#   pp mp3.header
    pp mp3.tag

  end

  puts
end

