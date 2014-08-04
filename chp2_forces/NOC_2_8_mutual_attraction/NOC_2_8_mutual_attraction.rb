# NOC_2_8_mutual_attraction
# http://natureofcode.com

class Mover
  attr_reader :mass, :velocity, :location

  G = 0.4

  def initialize(x, y, m)
    @location = PVector.new(x, y)
    @velocity = PVector.new(0, 0)
    @acceleration = PVector.new(0, 0)
    @mass = m
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
    fill(0, 100)
    ellipse(@location.x, @location.y, @mass*24, @mass*24)
  end

  def attract(mover)
    force = PVector.sub(@location, mover.location)
    distance = force.mag
    distance = constrain(distance, 5.0, 25.0)
    force.normalize

    strength = (G * @mass * @mass) / (distance * distance)
    force.mult(strength)
    force
  end
end


# NOC_2_8_mutual_attraction
def setup
  size(800, 200)
  @movers = Array.new(20) { Mover.new(rand(width), rand(height), rand(0.1 .. 2)) }
end

def draw
  background(255)

  @movers.each do |m|
    @movers.each do |mm|
      unless m == mm
        force = mm.attract(m)
        m.apply_force(force)
      end
    end

    m.update
    m.display
  end
end
