# The Nature of Code
# http://natureofcode.com

# Evolution EcoSystem

# The World we live in
# Has bloops and food
require "food"
require "dna"
require "bloop"

class World
  def initialize(num, width, height)
    @food = Food.new(num, width, height)
    @bloops = Array.new(num) do
      loc = PVector.new(rand(width), rand(height))
      dna = DNA.new
      Bloop.new(loc, dna)
    end
  end

  def born(x, y)
    loc = PVector.new(x, y)
    dna = DNA.new
    @bloops << Bloop.new(loc, dna)
  end

  def run
    @food.run

    @bloops.each do |b|
      b.run
      b.eat(@food)

      child = b.reproduce
      @bloops << child if child
    end

    @bloops.delete_if{|b| b.dead? }
  end
end
