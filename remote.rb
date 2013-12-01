#!/usr/bin/env ruby
# encoding: UTF-8
# Written by: j on 11-30-2013 
# ruby 2.0.0p247
require 'net/telnet'
require 'open-uri'
# Plex Home Theatre, I think this uses a new port now. Plex-Ruby gem wouldn't work for me
module Plex
  HASH = { 'k' => 'moveUp', 'j' => 'moveDown', 'h' => 'moveLeft', 'l' => 'moveRight', 'K' => 'pageUp', 'J' => 'pageDown', ' ' => 'select', 'b' => 'back', 't' => 'toggleOSD' }
  def keypress key
    begin
      open("http://10.0.1.23:32400/system/players/10.0.1.23/navigation/#{HASH[key]}")
    rescue
      puts "can't connect to Plex" #would like something more helpful
    end
	end
  extend self
end
# Tivo Series 3
module Tivo
  @tiv = Net::Telnet::new('Host' => '10.0.1.5', 'Port' => 31339, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
  
# other commands that can be added: UP DOWN LEFT RIGHT SELECT TIVO LIVETV THUMBSUP THUMBSDOWN CHANNELUP CHANNELDOWN RECORD DISPLAY DIRECTV NUM0 NUM1 NUM2 NUM3 NUM4 NUM5 NUM6 NUM7 NUM8 NUM9 ENTER CLEAR PLAY PAUSE SLOW FORWARD REVERSE STANDBY NOWSHOWING REPLAY ADVANCE DELIMITER GUIDE

  HASH = { 'j' => 'CHANNELDOWN', 'k' => 'CHANNELUP', 'J' => 'DOWN', 'K' => 'UP','l' => 'RIGHT', 'h' => 'LEFT', 'g' => 'GUIDE', ' ' => 'SELECT', 'T' => 'THUMBSUP', 't' => 'THUMBSDOWN', 'r' => 'RECORD' }

	def keypress key
		begin
			@tiv.cmd("IRCODE #{HASH[key]}")
		rescue
      @tiv = Net::Telnet::new('Host' => '10.0.1.5', 'Port' => 31339, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
			@tiv.cmd("IRCODE #{HASH[key]}")
		end
	end
  extend self
end
# Yamaha RX-V473, probably works with several models
module Yamaha
  @yam = Net::Telnet::new('Host' => '10.0.1.9', 'Port' => 50000, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
  
  HASH = { 'k' => 'VOL=Up 5 dB', 'j' => 'VOL=Down 5 dB','p' => "PWR=On", 'P' => "PWR=Off", 'h' => "INP=HDMI1", 'l' => "INP=HDMI2" }
	def keypress key
		begin
			@yam.cmd("@MAIN:#{HASH[key]}")
		rescue
			@yam = Net::Telnet::new('Host' => '10.0.1.9', 'Port' => 50000, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
			@yam.cmd("@MAIN:#{HASH[key]}")
		end
	end
  extend self
end

class Remote
include Tivo
include Yamaha
@status = 'go'
@mode = 'Tivo'
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
      @mode = 'Plex'
    when 't'
      @mode = 'Tivo'
    when 'y'
      @mode = 'Yamaha'
    end
    system('clear')
    p @mode
  when 'q'
    @status = 'q'
  when 'H'
    puts "#{@mode} commands"
    puts "Key : Command"
    Object.const_get(@mode)::HASH.each { |key,value| puts " #{key}  : #{value}" }
  else
		Object.const_get(@mode).keypress(str)
  end
end
end
Remote.new
