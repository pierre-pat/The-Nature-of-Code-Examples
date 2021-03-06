# The Nature of Code
# http://natureofcode.com

class Mover
  def initialize(width, height)
    @location = PVector.new(rand(width/2), rand(height/2))
    @velocity = PVector.new(0, 0)
    @topspeed = 6
  end

  def update
    mouse = PVector.new(mouse_x, mouse_y)
    acceleration = PVector.sub(mouse, @location)
    acceleration.normalize
    acceleration.mult(0.2)

    @velocity.add(acceleration)
    @velocity.limit(@topspeed)
    @location.add(@velocity)
  end

  def display
    stroke(0)
    stroke_weight(2)
    fill(127)
    ellipse(@location.x, @location.y, 48, 48)
  end
end

# NOC_1_10_motion101_acceleration
def setup
  size(800, 200)
  @mover = Mover.new(width, height)
end

def draw
  background(255)

  @mover.update
  @mover.display
end
