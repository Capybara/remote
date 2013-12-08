require_relative 'commandable'
# Plex Home Theatre, I think this uses a different port than Plex. Plex-Ruby gem wouldn't work for me
class Plex
  include Commandable
  attr_reader :cmds, :insert_commands
  def initialize 
    @insert_commands = %w[ play stop rewind fastForward stepForward bigStepForward stepBack bigStepBack skipNext skipPrevious pause ]
    @cmds = { 'k' => 'moveUp', 'j' => 'moveDown', 'h' => 'moveLeft', 'l' => 'moveRight', 'K' => 'pageUp', 'J' => 'pageDown', ' ' => 'select', 'b' => 'back', 't' => 'toggleOSD' }
  end
  def ins(comm)
    open("http://10.0.1.23:32400/system/players/10.0.1.23/playback/#{comm}")
  end
  def keypress key
    open("http://10.0.1.23:32400/system/players/10.0.1.23/navigation/#{@cmds[key]}")
  end
end

