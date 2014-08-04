# NOC_4_06_ParticleSystemForces
class Particle
  attr_reader :location

  def initialize(location)
    @acceleration = PVector.new(0, 0)
    @velocity = PVector.new(rand(-1.0 .. 1), rand(-2 ..0))
    @location = location.get
    @lifespan = 255.0
    @mass = 1
  end

  def run
    update
    display
  end

  def apply_force(force)
    f = force.get
    f.div(@mass)
    @acceleration.add(f)
  end

  # Method to update location
  def update
    @velocity.add(@acceleration)
    @location.add(@velocity)
    @acceleration.mult(0)
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

class ParticleSystem
  def initialize(origin)
    @origin = origin
    @particles = []
  end

  def add_particle
    @particles << Particle.new(@origin)
  end

  def apply_force(f)
    @particles.each{|p| p.apply_force(f)}
  end

  def run
    @particles.each{ |p| p.run }
    @particles.delete_if{ |p| p.is_dead? }
  end
end

def setup
  size(640,360)
  @ps = ParticleSystem.new(PVector.new(width/2, 50))
end

def draw
  background(255)

  # Apply gravity force to all Particles
  gravity = PVector.new(0, 0.1)
  @ps.apply_force(gravity)

  @ps.add_particle
  @ps.run
end
