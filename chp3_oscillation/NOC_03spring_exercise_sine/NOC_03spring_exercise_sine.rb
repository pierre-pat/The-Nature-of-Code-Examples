# NOC_03spring_exercise_sine
# The Nature of Code
# http://natureofcode.com

def setup
  size(640, 360)
  smooth
  @angle = 0
  @velocity = 0.05
end

def draw
  background(255)

  x = width/2
  y = map(sin(@angle), -1, 1, 50, 250)
  @angle += @velocity

  ellipse_mode(CENTER)
  stroke(0)
  fill(175)
  line(x, 0, x, y)
  ellipse(x, y, 20, 20)
end
