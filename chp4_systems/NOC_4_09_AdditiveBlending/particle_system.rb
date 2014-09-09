#  NOC_4_09_AdditiveBlending
# The Nature of Code
# http://natureofcode.com

require 'forwardable'
require_relative 'particle'

module Runnable
  def run
    self.reject! { |item| item.dead? }
    each    { |item| item.run }
  end
end

class ParticleSystem
  include Processing::Proxy, Enumerable, Runnable
  extend Forwardable
  def_delegators(:@particles, :reject!, :<<, :each)

  def initialize(num, origin)
    @origin = origin
    @img = load_image("#{Dir.pwd}/data/texture.png")
    @particles = Array.new(num) { Particle.new(@origin, @img) }
  end

  def add_particle(p = nil)
    p ||= Particle.new(@origin, @img)
    self << p
  end

  def dead?
    self.empty?
  end
end
