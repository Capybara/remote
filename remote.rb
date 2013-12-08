#!/usr/bin/env ruby
# encoding: UTF-8
# Written by: j on 11-30-2013 
# ruby 2.0.0p247
require_relative 'tivo'
require_relative 'plex'
require_relative 'yamaha'
include Pressable
def mode
  puts "Enter control mode: "
  puts " p : Plex"
  puts " t : Tivo"
  puts " y : Yamaha"
  case inp = get_press
  when 'p'
    @mode = Plex
    Yamaha.new.keypress('h')
  when 't'
    @mode = Tivo
    Yamaha.new.keypress('l')
  when 'y'
    @mode = Yamaha
  end
  system('clear')
  p @mode
end
def help_me
  puts "#{@mode} commands"
  puts "Key : Command"
  puts " H  : help"
  puts " q  : quit"
  @mode.new.cmds.each { |key,value| puts " #{key}  : #{value}" }
end
#---------------------------------------------------------------------------
@status = 'go'
@mode = Tivo
until @status == 'q'
  case @key = get_press
  when 'm'
    mode
  when 'i'
    @mode.new.insert_c
  when 'q'
    @status = 'q'
  when 'H'
    help_me
  else
    @mode.new.keypress(@key)
  end
end
