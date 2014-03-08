# The Nature of Code
# Daniel Shiffman
# http:#natureofcode.com

# An animated drawing of a Neural Network

class Connection
  include Processing::Proxy	
  # Connection is from A to B
  attr_reader :a, :b, :weight, :sending, :sender, :output
  
  # Need to store the output for when its time to pass along
  @output = 0
  
  def initialize(from, to, w)
    @weight, @a, @b = w, from, to
    @sending = false
    @sender = Vec2D.new
  end
  
  
  # The Connection is active
  def feedforward(val)
    @output = val * weight      # Compute output
    @sender = a.origin          # Start animation at originating neuron
    @sending = true             # Turn on sending
  end
  
  # Update traveling sender
  def update
    if (sending)
      # Use a simple interpolation
      sender.x = lerp(sender.x, b.xpos, 0.1)
      sender.y = lerp(sender.y, b.ypos, 0.1)
      d = Vec2D.dist(sender, b.location)
      # If we've reached the end
      if (d < 1)
        # Pass along the output!
        b.feedforward(output)
        @sending = false
      end
    end
  end
  
  # Draw line and traveling circle
  def display
    stroke(0)
    stroke_weight(1 + weight * 4)
    line(a.xpos, a.ypos, b.xpos, b.ypos)
    
    if (sending)
      fill(0)
      stroke_weight(1)
      ellipse(sender.x, sender.y, 16, 16)
    end
  end
end

