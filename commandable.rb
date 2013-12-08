require 'net/telnet'
require 'open-uri'
module Commandable
  def get_press
    begin
      system("stty raw -echo")
      STDIN.getc
    ensure
      system("stty -raw echo")
    end
  end

  def insert_c
    @playback = %w[ play stop rewind fastForward stepForward bigStepForward stepBack bigStepBack skipNext skipPrevious pause ]
    begin
      system('clear')
      command = gets.chomp
      if self.class == Plex && @playback.include?("#{command}")
        open("http://10.0.1.23:32400/system/players/10.0.1.23/playback/#{command}")
      else
        puts "Commands are:"
        puts @playback
      end
    rescue
      'not available yet'
    end
  end

  def keypress key
    begin
      if self.class == Plex
        open("http://10.0.1.23:32400/system/players/10.0.1.23/navigation/#{@cmds[key]}")
      else
        con = Net::Telnet::new('Host' => @host, 'Port' => @port, 'Wait-time' => 1, 'Prompt' => /.*/, 'Telnet-mode' => false)
        con.cmd("#{@prefix + @cmds[key]}")
        con.close
      end
    rescue
      puts "#{key} is not a valid command, press 'H' for help"
    end
  end
end

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
