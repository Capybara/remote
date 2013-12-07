#!/usr/bin/env ruby
# encoding: UTF-8
# Written by: j on 11-30-2013 
# ruby 2.0.0p247
require_relative 'tivo'
require_relative 'plex'
require_relative 'yamaha'

@status = 'go'
@mode = Tivo
until @status == 'q'
  begin
    system("stty raw -echo")
    str = STDIN.getc
  ensure
    system("stty -raw echo")
  end
  case str.chr
  when 'm'
    puts "Enter control mode: "
    puts " p : Plex"
    puts " t : Tivo"
    puts " y : Yamaha"
    begin
      system("stty raw -echo")
      inp = STDIN.getc
    ensure
      system("stty -raw echo")
    end
    case inp.chr
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
  when 'i'
    @mode.new.insert_c
  when 'q'
    @status = 'q'
  when 'H'
    puts "#{@mode} commands"
    puts "Key : Command"
    puts " H  : help"
    puts " q  : quit"
    @mode.new.cmds.each { |key,value| puts " #{key}  : #{value}" }
  else
    @mode.new.keypress(str)
  end
end
