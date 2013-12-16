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

  def send_command command
    begin
        con = Net::Telnet::new('Host' => @host, 'Port' => @port, 'Wait-time' => 1, 'Prompt' => /.*/, 'Telnet-mode' => false)
        con.cmd("#{command}")
        con.close
    rescue
      puts "#{command} is not a valid command, press 'H' for help"
    end
  end
  def keypress key
    begin
      send_command "#{@prefix + @cmds[key]}"
    rescue
      puts "#{key} is not a valid command, press 'H' for help"
    end
  end
end
