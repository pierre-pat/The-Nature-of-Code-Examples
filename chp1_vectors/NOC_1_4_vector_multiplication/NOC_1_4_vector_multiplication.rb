# NOC_1_4_vector_multiplication
# The Nature of Code
# http://natureofcode.com
# Example 1-4: Vector multiplication

def setup
  size(800, 200)
  smooth()
end

def draw
  background(255)

  mouse = PVector.new(mouse_x, mouse_y)
  center = PVector.new(width/2, height/2)
  mouse.sub(center)

  # Multiplying a vector!  The vector is now half its original size (multiplied by 0.5).
  mouse.mult(0.5)

  translate(width/2, height/2)
  stroke_weight(2)
  stroke(0)
  line(0, 0, mouse.x, mouse.y)
end
