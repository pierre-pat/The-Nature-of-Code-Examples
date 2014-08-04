# The Nature of Code
# http://natureofcode.com

# Simple Particle System
# A simple Particle class

class Particle

  def initialize(location)
    @acceleration = PVector.new(0, 0.05)
    @velocity = PVector.new(rand(-1.0 .. 1), rand(-1 ..0))
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
  size(640, 360)
  @particles = []
end

def draw
  background(255)

  @particles << Particle.new(PVector.new(width/2,50))

  @particles.each{|p| p.run}
  @particles.delete_if{ |p| p.is_dead? }
end
