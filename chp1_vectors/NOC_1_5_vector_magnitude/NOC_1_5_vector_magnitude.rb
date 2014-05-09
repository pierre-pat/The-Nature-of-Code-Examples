# NOC_1_5_vector_magnitude
# The Nature of Code
# http://natureofcode.com
# Example 1-5: Vector magnitude
load_library :vecmath

def setup
  size(800, 200)
  smooth
end

def draw
  background(255)

  mouse = Vec2D.new(mouse_x, mouse_y)
  center = Vec2D.new(width/2, height/2)
  mouse -= center

  m = mouse.mag
  fill(0)
  no_stroke
  rect(0, 0, m, 10)

  translate(width/2, height/2)
  stroke(0)
  stroke_weight(2)
  line(0, 0, mouse.x, mouse.y)
end
