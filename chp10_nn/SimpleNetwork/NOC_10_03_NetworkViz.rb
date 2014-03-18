# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# A static drawing of a Neural Network
load_library :neural_network, :vecmath

attr_reader :network

def setup
  size(640, 360) 
  # Create the Network object
  @network = Network.new(width/2,height/2)
  
  # Create a bunch of s
  a = Neuron.new(-200, 0)
  b = Neuron.new(0, 75)
  c = Neuron.new(0, -75)
  d = Neuron.new(200, 0)
  
  # Connect them
  network.connect(a, b)
  network.connect(a, c)
  network.connect(b, d)
  network.connect(c, d)
  
  # Add them to the Network
  network.add_neuron(a)
  network.add_neuron(b)
  network.add_neuron(c)
  network.add_neuron(d)
end

def draw
  background(255)
  # Draw the Network
  network.display  
  no_loop
end

