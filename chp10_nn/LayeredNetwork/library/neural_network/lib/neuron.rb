# Daniel Shiffman
# The Nature of Code
# http:#natureofcode.com

# An animated drawing of a Neural Network

class Neuron
  include Processing::Proxy	
  # Neuron has a location
  attr_reader :location, :connections, :sum, :r
  
  def initialize(x, y)
    @sum = 0
    @r = 32
    @location = Vec2D.new(x, y)
    @connections = []
  end
  
  # Add a Connection
  def join(c)
    connections << c
  end 
  
  def origin
    return location.dup
  end
  
  def xpos
    return location.x
  end
  
  def ypos
    return location.y
  end
  
  # Receive an input
  def feedforward(input)
    # Accumulate it
    @sum += input
    # Activate it?
    if (sum > 1)
      fire
      @sum = 0;  # Reset the sum to 0 if it fires
    end
  end
  
  # The Neuron fires
  def fire
    @r = 64;   # It suddenly is bigger
    
    # We send the output through all connections
    connections.each {|c| c.feedforward(sum)}
  end
  
  # Draw it as a circle
  def display
    stroke(0)
    stroke_weight(1)
    # Brightness is mapped to sum
    b = map(sum, 0, 1, 255, 0)
    fill(b)
    ellipse(xpos, ypos, r, r)
    
    # Size shrinks down back to original dimensions
    @r = lerp(r, 32, 0.1)
  end
end

