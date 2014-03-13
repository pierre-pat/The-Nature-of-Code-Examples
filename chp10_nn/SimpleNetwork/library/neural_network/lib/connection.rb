# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# An animated drawing of a Neural Network

class Connection
  include Processing::Proxy
  
  attr_reader :neuron_a, :neuron_b, :weight, :sending, :sender, :output
  
  def initialize(from, to, w)
    @weight = w
    @neuron_a = from
    @neuron_b = to
    @sending = false
    @output = 0
  end
  
  
  # The Connection is active
  def feedforward(val)
    @output = val * weight             # Compute output
    @sender = neuron_a.location.dup    # Start animation at Neuron A
    @sending = true                    # Turn on sending
  end
  
  # Update traveling sender
  def update
    if (sending)
      # Use a simple interpolation
      sender.x = lerp(sender.x, neuron_b.location.x, 0.1)
      sender.y = lerp(sender.y, neuron_b.location.y, 0.1)
      d = Vec2D.dist(sender, neuron_b.location)
      # If we've reached the end
      if (d < 1)
        # Pass along the output!
        neuron_b.feedforward(output)
        @sending = false
      end
    end
  end
  
  # Draw line and traveling circle
  def display
    stroke(0)
    stroke_weight(1 + weight * 4)
    line(neuron_a.location.x, neuron_a.location.y, neuron_b.location.x, neuron_b.location.y)
    
    if (sending)
      fill(0)
      stroke_weight(1)
      ellipse(sender.x, sender.y, 16, 16)
    end
  end
end

