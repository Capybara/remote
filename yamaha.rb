require_relative 'commandable'
# Yamaha RX-V473, probably works with several models
class Yamaha
  attr_reader :cmds
  include Commandable
  def initialize
    @host, @port, @prefix = "10.0.1.9", 50000, "@MAIN:"
    @cmds = { 'k' => 'VOL=Up 5 dB', 'j' => 'VOL=Down 5 dB','p' => "PWR=On", 'P' => "PWR=Off", 'h' => "INP=HDMI1", 'l' => "INP=HDMI2" }
  end
end
