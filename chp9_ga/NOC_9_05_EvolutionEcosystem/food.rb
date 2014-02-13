# The Nature of Code
# http://natureofcode.com

# Evolution EcoSystem

# A collection of food in the world

class Food
  attr_reader :food
  def initialize(num, width, height)
    @food = Array.new(num) { PVector.new(rand(width), rand(height)) }
  end

  def add(loc)
    @food << loc.get
  end

  def run
    @food.each do |f|
      $app.stroke(0)
      $app.fill(175)
      $app.rect(f.x, f.y, 8, 8)
    end

    @food << PVector.new(rand($app.width), rand($app.height)) if rand < 0.001
  end
end
