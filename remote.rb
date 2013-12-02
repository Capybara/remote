#!/usr/bin/env ruby
# encoding: UTF-8
# Written by: j on 11-30-2013 
# ruby 2.0.0p247
require 'net/telnet'
require 'open-uri'
# Plex Home Theatre, I think this uses a new port now. Plex-Ruby gem wouldn't work for me
class Plex
  CMDS = { 'k' => 'moveUp', 'j' => 'moveDown', 'h' => 'moveLeft', 'l' => 'moveRight', 'K' => 'pageUp', 'J' => 'pageDown', ' ' => 'select', 'b' => 'back', 't' => 'toggleOSD' }
  def keypress key
    begin
      open("http://10.0.1.23:32400/system/players/10.0.1.23/navigation/#{CMDS[key]}")
    rescue
      puts "can't connect to Plex" #would like something more helpful
    end
  end
end

# Tivo Series 3
class Tivo
  CMDS = { 'j' => 'CHANNELDOWN', 'k' => 'CHANNELUP', 'J' => 'DOWN', 'K' => 'UP','l' => 'RIGHT', 'h' => 'LEFT', 'g' => 'GUIDE', ' ' => 'SELECT', 'T' => 'THUMBSUP', 't' => 'THUMBSDOWN', 'r' => 'RECORD' }
  def initialize 
    host="10.0.1.5"
    port=31339
    @tiv = Net::Telnet::new('Host' => host, 'Port' => port, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
  end
  def keypress key
    begin
      @tiv.cmd("IRCODE #{CMDS[key]}")
      @tiv.close
    rescue
      @tiv = Net::Telnet::new('Host' => '10.0.1.5', 'Port' => 31339, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
      @tiv.cmd("IRCODE #{CMDS[key]}")
      @tiv.close
    end
  end
end

# Yamaha RX-V473, probably works with several models
class Yamaha
  CMDS = { 'k' => 'VOL=Up 5 dB', 'j' => 'VOL=Down 5 dB','p' => "PWR=On", 'P' => "PWR=Off", 'h' => "INP=HDMI1", 'l' => "INP=HDMI2" }
  def initialize host="10.0.1.9", port=50000
    @yam = Net::Telnet::new('Host' => host, 'Port' => port, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
  end
  def keypress key
    begin
      @yam.cmd("@MAIN:#{CMDS[key]}")
      @yam.close
    rescue
      @yam = Net::Telnet::new('Host' => host, 'Port' => port, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
      @yam.cmd("@MAIN:#{CMDS[key]}")
      @yam.close
    end
  end
end

#class Remote
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
    @mode::CMDS.each { |key,value| puts " #{key}  : #{value}" }
  else
    @mode.new.keypress(str)
  end
end
