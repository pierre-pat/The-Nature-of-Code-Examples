# NOC_3_02_forces_angular_motion
# The Nature of Code
# http://natureofcode.com

class Mover
  attr_reader :location, :mass

  def initialize(m, x, y)
    @mass = m
    @location = PVector.new(x,y)
    @velocity = PVector.new(random(-1, 1), random(-1, 1))
    @acceleration = PVector.new(0, 0)
    @angle = 0

    @a_velocity = 0
    @a_acceleration = 0
  end

  def apply_force(force)
    f = PVector.div(force, @mass)
    @acceleration.add(f)
  end

  def update
    @velocity.add(@acceleration)
    @location.add(@velocity)

    @a_acceleration = @acceleration.x / 10.0
    @a_velocity += @a_acceleration
    @a_velocity = constrain(@a_velocity, -0.1, 0.1)
    @angle += @a_velocity

    @acceleration.mult(0)
  end

  def display
    stroke(0)
    fill(175, 200)
    rect_mode(CENTER)
    push_matrix
    translate(@location.x, @location.y)
    rotate(@angle)
    rect(0, 0, @mass*16, @mass*16)
    pop_matrix
  end
end

class Attractor

  def initialize(width, height)
    @location = PVector.new(width/2, height/2)
    @mass = 20
    @g = 0.4
  end

  def attract(mover)
    force = PVector.sub(@location, mover.location)
    distance = force.mag
    distance = constrain(distance, 5.0, 25.0)
    force.normalize
    strength = (@g * @mass * mover.mass) / (distance * distance)
    force.mult(strength)
    force
  end

  def display
    stroke(0)
    stroke_weight(2)
    fill(127)
    ellipse(@location.x, @location.y, 48, 48)
  end
end

# NOC_3_02_forces_angular_motion
def setup
  size(800, 200)
  background(255)
  @movers = Array.new(20) { Mover.new(random(0.1, 2), random(width), random(height)) }
  @a = Attractor.new(width, height)
end

def draw
  background(255)

  @a.display

  @movers.each do |m|
    force = @a.attract(m)
    m.apply_force(force)
    m.update
    m.display
  end
end
