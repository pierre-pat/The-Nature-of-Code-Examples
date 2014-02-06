# The Nature of Code
# NOC_6_01_Seek_trail

class Vehicle
  attr_reader :history
  def initialize(x, y, world, safe_distance)
    @acceleration = PVector.new
    @velocity = PVector.new(3, -2)
    @location = PVector.new(x, y)
    @r = 6
    @maxspeed = 3
    @maxforce = 0.15
    @world = world
    @d = safe_distance
  end

  def run
    update
    display
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

  def boundaries
    desired =  if @location.x < @d
                        PVector.new(@maxspeed, @velocity.y)
                      elsif @location.x > @world.width - @d
                        PVector.new(-@maxspeed, @velocity.y)
                      elsif @location.y < @d
                        PVector.new(@velocity.x, @maxspeed)
                      elsif @location.y > @world.height - @d
                        PVector.new(@velocity.x, -@maxspeed)
                      end

    if desired != nil
      desired.normalize
      desired.mult(@maxspeed)
      steer = PVector.sub(desired, @velocity)
      steer.limit(@maxforce)
      apply_force(steer)
    end
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
  @d = 25
  @v = Vehicle.new(width/2, height/2, self, @d)
end

def draw
  background(255)

  stroke(175)
  no_fill
  rectMode(CENTER)
  rect(width/2, height/2, width-@d*2, height-@d*2)

  # Call the appropriate steering behaviors for our agents
  @v.boundaries
  @v.run
end
