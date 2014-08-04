# NOC_02forces_many_attraction_3D
# The Nature of Code
# http://natureofcode.com

# Attraction
# A class for a draggable attractive body in our world
class Attractor

  def initialize
    @location = PVector.new(0, 0)
    @mass = 20
    @g = 0.4
  end


  def attract(mover)
    force = PVector.sub(@location, mover.location)               # Calculate direction of force
    distance = force.mag                                         # Distance between objects
    distance = constrain(distance, 5.0, 25.0)                   # Limiting the distance to eliminate "extreme" results for very close or very far objects
    force.normalize                                              # Normalize vector (distance doesn't matter here, we just want this vector for direction)
    strength = (@g * @mass * mover.mass) / (distance * distance) # Calculate gravitional force magnitude
    force.mult(strength)                                         # Get force vector --> magnitude * direction
    force
  end

  def display
    stroke(255)
    no_fill
    push_matrix
    translate(@location.x, @location.y, @location.z)
    sphere(@mass*2)
    pop_matrix
  end
end

class Mover
  attr_reader :location, :mass

  def initialize(m, x, y, z)
    @mass = m
    @location = PVector.new(x, y, z)
    @velocity = PVector.new(1, 0)
    @acceleration = PVector.new(0, 0)
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
    no_stroke
    fill(255)
    push_matrix
    translate(@location.x, @location.y, @location.z)
    sphere(@mass*8)
    pop_matrix
  end

  def check_edges
    if @location.x > width
      @location.x = 0;
    elsif @location.x < 0
      @location.x = width
    end

    if @location.y > height
      @velocity.y *= -1
      @location.y = height
    end
  end
end

# NOC_02forces_many_attraction_3D
def setup
  size(640, 360, P3D)
  background(255)
  @movers = Array.new(10) { Mover.new(rand(0.1 .. 2), rand(-width/2 .. width/2), rand(-height/2 .. height/2), rand(-100 ..100)) }
  @attractor = Attractor.new
  @angle = 0
end

def draw
  background(0)
  sphere_detail(8)
  lights
  translate(width/2, height/2)
  rotate_y(@angle)

  @attractor.display

  @movers.each do |m|
    force = @attractor.attract(m)
    m.apply_force(force)
    m.update
    m.display
  end

  @angle += 0.003
end
