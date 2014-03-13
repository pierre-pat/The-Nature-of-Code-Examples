# The Nature of Code
# Daniel Shiffman
# http:#natureofcode.com

# An animated drawing of a Neural Network
load_libraries :vecmath, :neural_network

attr_reader :network

def setup
  size(640, 360); 
  # Create the Network object
  @network = Network.new(width/2, height/2)

  # Create a bunch of Neurons
  a = Neuron.new(-275, 0)
  b = Neuron.new(-150, 0)
  c = Neuron.new(0, 75)
  d = Neuron.new(0, -75)
  e = Neuron.new(150, 0)
  f = Neuron.new(275, 0)

  # Connect them
  network.connect(a, b, 1.0)
  network.connect(b, c, rand)
  network.connect(b, d, rand)
  network.connect(c, e, rand)
  network.connect(d, e, rand)
  network.connect(e, f, 1.0)

  # Add them to the Network
  network.add_neuron(a)
  network.add_neuron(b)
  network.add_neuron(c)
  network.add_neuron(d)
  network.add_neuron(e)
  network.add_neuron(f)
end

def draw
  background(255)
  # Update and display the Network
  network.update
  network.display
  
  # Every 30 frames feed in an input
  if (frame_count % 30 == 0)
    network.feedforward(rand)
  end
end

