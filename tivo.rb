require_relative 'pressable'
# Tivo Series 3
class Tivo
  attr_reader :cmds
  include Pressable
  def initialize
    @host, @port, @prefix = "10.0.1.5", 31339, "IRCODE "
    @cmds = { 'j' => 'CHANNELDOWN', 'k' => 'CHANNELUP', 'J' => 'DOWN', 'K' => 'UP','l' => 'RIGHT', 'h' => 'LEFT', 'g' => 'GUIDE', ' ' => 'SELECT', 'T' => 'THUMBSUP', 't' => 'THUMBSDOWN', 'r' => 'RECORD' }
  end
end
