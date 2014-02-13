# NOC_02forces_many_mutual_boundaries
# The Nature of Code
# http://natureofcode.com

class Mover
  attr_reader :location, :mass

  def initialize(m, x, y)
    @mass = m
    @location = PVector.new(x, y)
    @velocity = PVector.new(0, 0)
    @acceleration = PVector.new(0, 0)
    @g = 1
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
    fill(175, 200)
    ellipse(@location.x, @location.y, @mass*16, @mass*16)
  end

  def attract(mover)
    force = PVector.sub(@location, mover.location)                   # Calculate direction of force
    distance = force.mag                                         # Distance between objects
    distance = constrain(distance, 5.0, 25.0)                    # Limiting the distance to eliminate "extreme" results for very close or very far objects
    force.normalize                                              # Normalize vector (distance doesn't matter here, we just want this vector for direction

    strength = (@g * @mass * mover.mass) / (distance * distance) # Calculate gravitional force magnitude
    force.mult(strength)                                         # Get force vector --> magnitude * direction
    force
  end

  def boundaries(width, height)
    d = 50
    force = PVector.new(0, 0)

    if @location.x < d
      force.x = 1
    elsif @location.x > width-d
      force.x = -1
    end

    if @location.y < d
      force.y = 1
    elsif @location.y > height-d
      force.y = -1
    end

    force.normalize
    force.mult(0.1)

    apply_force(force)
  end
end

def setup
  size(640, 360)
  @movers = Array.new(20)  { Mover.new(random(1, 2), random(width), random(height)) }
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

    m.boundaries(width, height)
    m.update
    m.display
  end
end
