# The Nature of Code
# http://natureofcode.com

# Simple Particle System
# A simple Particle class
load_library :vecmath
require_relative 'particle'

attr_reader :particles

def setup
  size(640, 360)
  @particles = []
end

def draw
  background(255)
  particles << Particle.new(Vec2D.new(width / 2, 50))
  particles.each { |p| p.run }
  particles.reject! { |p| p.dead? }
end
