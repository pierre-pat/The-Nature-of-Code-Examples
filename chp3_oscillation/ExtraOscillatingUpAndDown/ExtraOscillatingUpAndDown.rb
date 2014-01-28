# ExtraOscillatingUpAndDown
def setup
  size(400,400)
  @angle = 0
end

def draw
  background(255)
  y = 100*sin(@angle)
  @angle += 0.02

  fill(127)
  translate(width/2, height/2)
  line(0, 0, 0, y)
  ellipse(0, y, 16, 16)
end
