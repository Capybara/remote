#!/usr/bin/env ruby
# encoding: UTF-8
# Written by: j on 11-30-2013 
# ruby 2.0.0p247
require 'net/telnet'
module Tivo
		@tiv = Net::Telnet::new('Host' => '10.0.1.5', 'Port' => 31339, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
		
		ARR = %w[ UP DOWN LEFT RIGHT SELECT TIVO LIVETV THUMBSUP THUMBSDOWN CHANNELUP CHANNELDOWN RECORD DISPLAY DIRECTV NUM0 NUM1 NUM2 NUM3 NUM4 NUM5 NUM6 NUM7 NUM8 NUM9 ENTER CLEAR PLAY PAUSE SLOW FORWARD REVERSE STANDBY NOWSHOWING REPLAY ADVANCE DELIMITER GUIDE ]


		ARR.each do |method|
			@method = method
			define_method method.downcase do
				@tiv.cmd("IRCODE #{method}")
			end
		end
		extend self
end

module Yamaha
		@yam = Net::Telnet::new('Host' => '10.0.1.9', 'Port' => 50000, 'Wait-time' => 0.1, 'Prompt' => /.*/, 'Telnet-mode' => false)
		
		HASH = { 'k' => 'VOL=Up 5 dB', 'j' => 'VOL=Down 5 dB','p' => "PWR=On", 'P' => "PWR=Off", 'h' => "INP=HDMI1", 'l' => "INP=HDMI2" }
		HASH.each_key do |method|
			define_method method do
				@yam.cmd("@MAIN:#{HASH[method]}")
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
#	@status = gets.chomp
#	Tivo.send(@status) if Tivo::ARR.include?(@status.upcase)
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
		p @mode
	when 'k'
		if @mode == 'Tivo'
			Tivo.send('channelup')
		end
	when 'j'
		if @mode == 'Tivo'
			Tivo.send('channeldown')
		elsif @mode == 'Yamaha'
			Yamaha.send('j')
		end
	when 'K'
		if @mode == 'Tivo'
			Tivo.send('up')
		end
	when 'J'
		if @mode == 'Tivo'
			Tivo.send('down')
		end
	when 'h'
		if @mode == 'Tivo'
			Tivo.send('left')
		end
	when 'l'
		if @mode == 'Tivo'
			Tivo.send('right')
		end
	when ' '
		if @mode == 'Tivo'
			Tivo.send('select')
		end
	when 'q'
		@status = 'q'
	end
end
end
Remote.new
