require_relative 'pressable'
# Plex Home Theatre, I think this uses a different port than Plex. Plex-Ruby gem wouldn't work for me
class Plex
  attr_reader :cmds
  include Pressable
  def initialize 
    @cmds = { 'k' => 'moveUp', 'j' => 'moveDown', 'h' => 'moveLeft', 'l' => 'moveRight', 'K' => 'pageUp', 'J' => 'pageDown', ' ' => 'select', 'b' => 'back', 't' => 'toggleOSD' }
  end
end

