# NOC_3_07_oscillating_objects
# The Nature of Code
# http://natureofcode.com

class Oscillator

  def initialize(width, height)
    @angle = PVector.new
    @velocity = PVector.new(random(-0.05, 0.05), random(-0.05, 0.05))
    @amplitude = PVector.new(random(20, width/2), random(20, height/2))
  end

  def oscillate
    @angle.add(@velocity)
  end

  def display(width, height)
    x = sin(@angle.x)*@amplitude.x
    y = sin(@angle.y)*@amplitude.y

    push_matrix
    translate(width/2, height/2)
    stroke(0)
    stroke_weight(2)
    fill(127, 127)
    line(0, 0, x, y)
    ellipse(x, y, 32, 32)
    pop_matrix
  end
end

# NOC_3_07_oscillating_objects
def setup
  size(800, 200)
  smooth
  @oscillators = Array.new(10) { Oscillator.new(width, height) }
  background(255)
end

def draw
  background(255)
  @oscillators.each do |o|
    o.oscillate
    o.display(width, height)
  end
end
