require_relative 'commandable'
# Tivo Series 3
class Tivo
  attr_reader :cmds
  include Commandable
  def initialize
    @host, @port, @prefix = "10.0.1.5", 31339, "IRCODE "
    @cmds = { 'j' => 'CHANNELDOWN', 'k' => 'CHANNELUP', 'J' => 'DOWN', 'K' => 'UP','l' => 'RIGHT', 'h' => 'LEFT', 'g' => 'GUIDE', ' ' => 'SELECT', 'T' => 'THUMBSUP', 't' => 'THUMBSDOWN', 'r' => 'RECORD' }
    @insert_commands = %w[ unavailable ]
  end
  def ins
    #
  end
  def channel(ch=gets.chomp)
      send_command "FORCECH #{ch}"
      system('clear')
  end
end
