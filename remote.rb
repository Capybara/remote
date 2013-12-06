#!/usr/bin/env ruby
# encoding: UTF-8
# Written by: j on 11-30-2013 
# ruby 2.0.0p247
require 'net/telnet'
require 'open-uri'
module Pressable
   def keypress key
     begin
       if self.class == Plex
         open("http://10.0.1.23:32400/system/players/10.0.1.23/navigation/#{@cmds[key]}")
       else
         con = Net::Telnet::new('Host' => @host, 'Port' => @port, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
         con.cmd("#{@prefix + @cmds[key]}")
         con.close
       end
     rescue
       puts "#{key} is not a valid command, press 'H' for help"
     end
   end
end
# Plex Home Theatre, I think this uses a new port now. Plex-Ruby gem wouldn't work for me
class Plex
  attr_reader :cmds
  include Pressable
  def initialize 
    @cmds = { 'k' => 'moveUp', 'j' => 'moveDown', 'h' => 'moveLeft', 'l' => 'moveRight', 'K' => 'pageUp', 'J' => 'pageDown', ' ' => 'select', 'b' => 'back', 't' => 'toggleOSD' }
  end
end

# Tivo Series 3
class Tivo
  attr_reader :cmds
  include Pressable
  def initialize
    @host, @port, @prefix = "10.0.1.5", 31339, "IRCODE "
    @cmds = { 'j' => 'CHANNELDOWN', 'k' => 'CHANNELUP', 'J' => 'DOWN', 'K' => 'UP','l' => 'RIGHT', 'h' => 'LEFT', 'g' => 'GUIDE', ' ' => 'SELECT', 'T' => 'THUMBSUP', 't' => 'THUMBSDOWN', 'r' => 'RECORD' }
  end
end

# Yamaha RX-V473, probably works with several models
class Yamaha
  attr_reader :cmds
  include Pressable
  def initialize
    @host, @port, @prefix = "10.0.1.9", 50000, "@MAIN:"
    @cmds = { 'k' => 'VOL=Up 5 dB', 'j' => 'VOL=Down 5 dB','p' => "PWR=On", 'P' => "PWR=Off", 'h' => "INP=HDMI1", 'l' => "INP=HDMI2" }
  end
end

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
