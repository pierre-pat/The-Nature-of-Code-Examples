# NOC_1_2_bouncingball_vectors
# The Nature of Code
# http://natureofcode.com
# Example 1-2: Bouncing Ball, with PVector!

def setup
  size(200,200)
  background(255)

  @location = PVector.new(100, 100)
  @velocity = PVector.new(2.5, 5)
end

def draw
  no_stroke
  fill(255, 10)
  rect(0, 0, width, height)

  # Add the current speed to the location.
  @location.add(@velocity)

  @velocity.x = -@velocity.x if @location.x > width or @location.x < 0
  @velocity.y = -@velocity.y if @location.y > height or @location.y < 0

  # Display circle at x location
  stroke(0)
  fill(175)
  ellipse(@location.x, @location.y, 16, 16)
end
