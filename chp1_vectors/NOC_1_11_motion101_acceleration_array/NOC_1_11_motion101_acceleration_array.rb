# The Nature of Code
# http://natureofcode.com

class Mover
  def initialize
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

# NOC_1_11_motion101_acceleration_array
def setup
  size(800, 200)
  @movers = Array.new(20) { Mover.new }
end

def draw
  background(255)

  @movers.each do |mover|
    mover.update
    mover.display
  end
end
