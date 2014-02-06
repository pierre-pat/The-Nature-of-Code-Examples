# The Nature of Code
# NOC_6_07_Separation
class Vehicle
  attr_reader :location
  def initialize(x, y)
    @location = PVector.new(x, y)
    @r = 12
    @maxspeed = 3
    @maxforce = 0.2
    @acceleration = PVector.new(0, 0)
    @velocity = PVector.new(0, 0)
  end

  def apply_force(force)
    @acceleration.add(force)
  end

  def separate(vehicles)
    desired_separation = @r*2
    sum = PVector.new
    count = 0

    vehicles.each do |other|
      d = PVector.dist(@location, other.location)
      if d > 0 and d < desired_separation
        diff = PVector.sub(@location, other.location)
        diff.normalize
        diff.div(d)
        sum.add(diff)
        count += 1
      end
    end

    if count > 0
      sum.div(count)
      sum.normalize
      sum.mult(@maxspeed)
      steer = PVector.add(sum, @velocity)
      steer.limit(@maxforce)
      apply_force(steer)
    end
  end

  def update
    @velocity.add(@acceleration)
    @velocity.limit(@maxspeed)
    @location.add(@velocity)
    @acceleration.mult(0)
  end

  def display
    fill(175)
    stroke(0)
    push_matrix
    translate(@location.x, @location.y)
    ellipse(0, 0, @r, @r)
    pop_matrix
  end

  def borders(width, height)
    @location.x = width + @r if @location.x < -@r
    @location.y = height + @r if @location.y < -@r
    @location.x = -@r if @location.x > width + @r
    @location.y = -@r if @location.y < -@r
  end
end

def setup
  size(640, 360)
  @vehicles = Array.new(100) { Vehicle.new(random(width), random(height)) }
end

def draw
  background(255)

  @vehicles.each do |v|
    v.separate(@vehicles)
    v.update
    v.borders(width, height)
    v.display
  end
end


def mouse_dragged
  @vehicles.add(Vehicle.new(mouse_x, mouse_y))
end
