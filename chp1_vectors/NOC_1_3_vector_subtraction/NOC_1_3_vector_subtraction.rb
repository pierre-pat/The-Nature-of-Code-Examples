# NOC_1_3_vector_subtraction.pde
# The Nature of Code
# http://natureofcode.com
# Example 1-3: Vector subtraction

def setup
  size(800, 200)
  smooth
end

def draw
  background(255)

  mouse = PVector.new(mouse_x, mouse_y)
  center = PVector.new(width/2, height/2)
  mouse.sub(center)

  translate(width/2, height/2)
  stroke_weight(2)
  stroke(0)
  line(0, 0, mouse.x, mouse.y)
end
