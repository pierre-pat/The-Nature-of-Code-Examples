# The Nature of Code
# http://natureofcode.com

class Mover
  attr_reader :mass
  def initialize(mass, x, y)
    @location = PVector.new(x, y)
    @velocity = PVector.new(0, 0)
    @acceleration = PVector.new(0, 0)
    @mass = mass
  end

  def apply_force(force)
    f = PVector.div(force, @mass)
    @acceleration.add(f)
  end

  def update
    @velocity.add(@acceleration)
    @location.add(@velocity)

    @acceleration.mult(0)
  end

  def display
    stroke(0)
    stroke_weight(2)
    fill(127)
    ellipse(@location.x, @location.y, @mass*16, @mass*16)
  end

  def check_edges(width, height)
    if @location.x > width
      @location.x = width
      @velocity.x *= -1
    elsif @location.x < 0
      @location.x = 0
      @velocity.x *= -1
    end

    if @location.y > height
      @location.y = height
      @velocity.y *= -1
    elsif @location.y < 0
      @location.y = 0
      @velocity.y *= -1
    end
  end
end

def setup
  size(800, 200)
  @movers = Array.new(20) { Mover.new(random(1, 4), 0, 0) }
end

def draw
  background(255)

  @movers.each do |m|
    wind = PVector.new(0.01, 0)
    gravity = PVector.new(0, 0.1*m.mass)

    m.apply_force(wind)
    m.apply_force(gravity)
    m.update
    m.display
    m.check_edges(width, height)
  end
end
