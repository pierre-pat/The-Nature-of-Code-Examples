# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# An animated drawing of a Neural Network
load_libraries :vecmath, :neural_network

attr_reader :network, :output

def setup
  size(640,360);
  # Create the Network object
  @network = Network.new(width / 2, height / 2)

  layers = 3
  inputs = 2

  @output = Neuron.new(250, 0)
  (0 ... layers).each do |i|
    inputs.times do |j|
      x = map1d(i, (0 .. layers), (-250 .. 300))
      y = map1d(j, (0 .. inputs-1), (-75 .. 75))
      n = Neuron.new(x, y)
      if (i > 0)
        (0 ... inputs).each do |k|
          prev = network.neurons[network.neurons.size - inputs + k - j]
          network.connect(prev, n, rand(0 ... 1.0))
        end
      end
      if (i == layers - 1)
        network.connect(n, output, rand(0 ... 1.0))
      end
      network.add_neuron(n)
    end
  end
  network.add_neuron(output)
end

def draw
  background(255)
  # Update and display the Network
  network.update
  network.display

  # Every 30 frames feed in an input
  if (frame_count % 30 == 0)
    network.feedforward(rand(0 ... 1.0), rand(0 ... 1.0))
  end
end

