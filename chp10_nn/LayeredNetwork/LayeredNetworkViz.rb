# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
load_library :neural_network, :vecmath

attr_reader :network

def setup
  size 640, 360
  @network = StaticNetwork.new 4, 3, 1
  smooth 4
end

def draw
  background 255
  network.display
end
