#!/usr/bin/env ruby
# encoding: UTF-8
# Written by: j on 11-30-2013 
# ruby 2.0.0p247
require 'net/telnet'
module Tivo
		@tiv = Net::Telnet::new('Host' => '10.0.1.5', 'Port' => 31339, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
		
		#ARR = %w[ UP DOWN LEFT RIGHT SELECT TIVO LIVETV THUMBSUP THUMBSDOWN CHANNELUP CHANNELDOWN RECORD DISPLAY DIRECTV NUM0 NUM1 NUM2 NUM3 NUM4 NUM5 NUM6 NUM7 NUM8 NUM9 ENTER CLEAR PLAY PAUSE SLOW FORWARD REVERSE STANDBY NOWSHOWING REPLAY ADVANCE DELIMITER GUIDE ]

		HASH = { 'j' => 'CHANNELDOWN', 'k' => 'CHANNELUP', 'J' => 'DOWN', 'K' => 'UP','l' => 'RIGHT', 'h' => 'LEFT', 'g' => 'GUIDE', ' ' => 'SELECT', 'T' => 'THUMBSUP', 't' => 'THUMBSDOWN', 'r' => 'RECORD' }

		HASH.each_key do |method|
			define_method method do
				begin
					@tiv.cmd("IRCODE #{HASH[method]}")
				rescue
					@tiv = Net::Telnet::new('Host' => '10.0.1.5', 'Port' => 31339, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
					@tiv.cmd("IRCODE #{HASH[method]}")
				end
			end
		end
		extend self
end

module Yamaha
		@yam = Net::Telnet::new('Host' => '10.0.1.9', 'Port' => 50000, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
		
		HASH = { 'k' => 'VOL=Up 5 dB', 'j' => 'VOL=Down 5 dB','p' => "PWR=On", 'P' => "PWR=Off", 'h' => "INP=HDMI1", 'l' => "INP=HDMI2" }
		HASH.each_key do |method|
			define_method method do
				begin
					@yam.cmd("@MAIN:#{HASH[method]}")
				rescue
					@yam = Net::Telnet::new('Host' => '10.0.1.9', 'Port' => 50000, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
					@yam.cmd("@MAIN:#{HASH[method]}")
				end
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
		if @mode == 'Tivo'
			@mode = 'Yamaha'
		elsif 
			@mode == 'Yamaha'
			@mode = 'Tivo'
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
		if Object.const_get(@mode).respond_to?(str)
			Object.const_get(@mode).send(str)
		else
			puts "Not a valid command, press 'H' for help"
		end
	end
end
end
Remote.new
