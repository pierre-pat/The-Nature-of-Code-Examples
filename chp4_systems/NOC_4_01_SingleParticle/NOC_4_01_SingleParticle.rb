# The Nature of Code
# http://natureofcode.com

# Simple Particle System
# A simple Particle class

class Particle

  def initialize(location)
    @acceleration = PVector.new(0, 0.05)
    @velocity = PVector.new(random(-1, 1), random(-1, 0))
    @location = location.get
    @lifespan = 255.0
  end

  def run
    update
    display
  end

  # Method to update location
  def update
    @velocity.add(@acceleration)
    @location.add(@velocity)
    @lifespan -= 2.0
  end

  # Method to display
  def display
    stroke(0, @lifespan)
    stroke_weight(2)
    fill(127, @lifespan)
    ellipse(@location.x, @location.y, 12, 12)
  end

  # Is the particle still useful?
  def is_dead?
    @lifespan < 0.0
  end
end

def setup
  size(800,200)
  @p = Particle.new(PVector.new(width/2,20))
  background(255)
  smooth
end

def draw
  background(255)

  @p.run
  @p = Particle.new(PVector.new(width/2,20)) if @p.is_dead?
end
