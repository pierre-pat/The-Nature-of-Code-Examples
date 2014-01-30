#  NOC_4_09_AdditiveBlending
# The Nature of Code
# http://natureofcode.com

class Particle

  def initialize(location, img)
    @acceleration = PVector.new(0, 0.05)
    @velocity = PVector.new(random(-1, 1), random(-1, 0))
    @velocity.mult(2)
    @location = location.get
    @img = img
    @lifespan = 255.0
  end

  def run
    update
    render
  end

  # Method to update location
  def update
    @velocity.add(@acceleration)
    @location.add(@velocity)
    @lifespan -= 2.0
  end

  # Method to display
  def render
    image_mode(CENTER)
    tint(@lifespan)
    image(@img, @location.x, @location.y)
  end

  # Is the particle still useful?
  def is_dead?
    @lifespan < 0.0
  end
end

class ParticleSystem
  def initialize(num, origin)
    @origin = origin
    @img = load_image("texture.png")
    @particles = Array.new(num) { Particle.new(@origin, @img) }
  end

  def add_particle(p=nil)
    p ||= Particle.new(@origin, @img)
    @particles << p
  end

  def run
    @particles.each{ |p| p.run }
    @particles.delete_if{ |p| p.is_dead? }
  end

  def is_dead?
    @particles.empty?
  end
end

def setup
  size(640, 340, P2D)
  @ps = ParticleSystem.new(0, PVector.new(width/2, 50))
end

def draw
  # blend_mode(ADD)
  background(0)
  @ps.run

  10.times{ @ps.add_particle }
end
