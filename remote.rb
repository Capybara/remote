#!/usr/bin/env ruby
# encoding: UTF-8
# Written by: j on 11-30-2013 
# ruby 2.0.0p247
require_relative 'tivo'
require_relative 'plex'
require_relative 'yamaha'
include Commandable

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
