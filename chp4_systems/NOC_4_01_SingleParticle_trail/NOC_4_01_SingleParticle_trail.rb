# The Nature of Code
# http://natureofcode.com

# Simple Particle System
# A simple Particle class

load_library :vecmath
require_relative 'particle'

def setup
  size(800, 200)
  @p = Particle.new(Vec2D.new(width / 2, 20))
  background(255)
  smooth 4
end

def draw
  # NB: in ruby-processing use mouse_pressed? instead of mousePressed
  # replacing a conditional with a guard clause
  return unless mouse_pressed?
  no_stroke
  fill(255, 5)
  rect(0, 0, width, height)
  @p.run
end
