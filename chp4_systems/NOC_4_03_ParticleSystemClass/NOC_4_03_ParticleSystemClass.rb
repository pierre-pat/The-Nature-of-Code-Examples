# NOC_4_03_ParticleSystemClass
load_library :vecmath
require_relative 'particle_system'

def setup
  size(640, 360)
  @particle_system = ParticleSystem.new(Vec2D.new(width / 2, 50))
end

def draw
  background(255)
  @particle_system.add_particle
  @particle_system.run
end
