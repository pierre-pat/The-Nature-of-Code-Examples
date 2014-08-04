# NOC_4_05_ParticleSystemInheritancePolymorphism
# The Nature of Code
# http://natureofcode.com
class Particle

  def initialize(location)
    @acceleration = PVector.new(0, 0.05)
    @velocity = PVector.new(rand(-1.0 .. 1), rand(-1 ..0))
    @location = location.get
    @lifespan = 255.0
  end

  def run(width, height)
    update
    display(width, height)
  end

  # Method to update location
  def update
    @velocity.add(@acceleration)
    @location.add(@velocity)
    @lifespan -= 2.0
  end

  # Method to display
  def display(width, height)
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

class Confetti < Particle
  def initialize(origin)
    super
  end

  def display(width, height)
    rect_mode(CENTER)
    fill(127, @lifespan)
    stroke(0, @lifespan)
    stroke_weight(2)
    push_matrix
    translate(@location.x, @location.y)
    theta = map(@location.x, 0, width, 0, TWO_PI*2)
    rotate(theta)
    rect(0, 0, 12, 12)
    pop_matrix
  end
end

class ParticleSystem
  def initialize(origin)
    @origin = origin
    @particles = []
  end

  def add_particle
    @particles << if rand < 0.5
                              Particle.new(@origin)
                            else
                              Confetti.new(@origin)
                            end
  end

  def run(width, height)
    @particles.each{ |p| p.run(width, height) }
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
  @particle_system.run(width, height)
end
