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
    begin
      system('clear')
      command = gets.chomp
      if @insert_commands.include?("#{command}")
        ins("#{command}")
      else
        puts "#{self.class} Insert Commands are:"
        puts @insert_commands
      end
    rescue
      'not available yet'
    end
  end

  def keypress key
    begin
        con = Net::Telnet::new('Host' => @host, 'Port' => @port, 'Wait-time' => 1, 'Prompt' => /.*/, 'Telnet-mode' => false)
        con.cmd("#{@prefix + @cmds[key]}")
        con.close
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
