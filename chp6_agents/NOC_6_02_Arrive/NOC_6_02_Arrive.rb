# The Nature of Code
# NOC_6_02_Arrive

class Vehicle
  def initialize(x, y)
    @acceleration = PVector.new
    @velocity = PVector.new(0, -2)
    @location = PVector.new(x, y)
    @r = 6
    @maxspeed =4
    @maxforce = 0.1
  end

  def apply_force(force)
    @acceleration.add(force)
  end

  def update
    @velocity.add(@acceleration)
    @velocity.limit(@maxspeed)
    @location.add(@velocity)
    @acceleration.mult(0)
  end

  def arrive(target)
    desired = PVector.sub(target, @location)
    d = desired.mag

    if d < 100 # scale with arbitrary damping withing 100 pixels
      m = map(d, 0, 100, 0, @maxspeed)
      desired.mag = m
    else
      desired.mag = @maxspeed
    end

    steer = PVector.sub(desired, @velocity)
    steer.limit(@maxforce)

    apply_force(steer)
  end

  def display
    theta = @velocity.heading2D + PI/2
    fill(127)
    stroke(0)
    stroke_weight(1)
    push_matrix
    translate(@location.x, @location.y)
    rotate(theta)
    begin_shape
    vertex(0, -@r*2)
    vertex(-@r, @r*2)
    vertex(@r, @r*2)
    end_shape(CLOSE)
    pop_matrix
  end
end

def setup
  size(640, 360)
  @v = Vehicle.new(width/2, height/2)
end

def draw
  background(255)

  mouse = PVector.new(mouse_x, mouse_y)

  fill(200)
  stroke(0)
  stroke_weight(2)
  ellipse(mouse.x, mouse.y, 48, 48)

  # Call the appropriate steering behaviors for our agents
  @v.arrive(mouse)
  @v.update
  @v.display
end
