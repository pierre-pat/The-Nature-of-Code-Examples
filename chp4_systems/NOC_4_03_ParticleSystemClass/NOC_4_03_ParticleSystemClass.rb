# NOC_4_03_ParticleSystemClass
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

class ParticleSystem
  def initialize(origin)
    @origin = origin
    @particles = []
  end

  def add_particle
    @particles << Particle.new(@origin)
  end

  def run
    @particles.each{ |p| p.run }
    @particles.delete_if{ |p| p.is_dead? }
  end
end

def setup
  size(640, 360)
  @particle_system = ParticleSystem.new(PVector.new(width/2, 50))
end

def draw
  background(255)
  @particle_system.add_particle
  @particle_system.run
end
