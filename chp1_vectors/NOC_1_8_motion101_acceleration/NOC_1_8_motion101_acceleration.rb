# The Nature of Code
# http://natureofcode.com

class Mover
  def initialize
    @location = PVector.new(rand(width/2), rand(height/2))
    @velocity = PVector.new(0, 0)
    @acceleration = PVector.new(-0.001, 0.01)
    @topspeed = 10
  end

  def update
    @velocity.add(@acceleration)
    @velocity.limit(@topspeed)
    @location.add(@velocity)
  end

  def display
    stroke(0)
    stroke_weight(2)
    fill(127)
    ellipse(@location.x, @location.y, 48, 48)
  end

  def check_edges
    if @location.x > width
      @location.x = 0
    elsif @location.x < 0
      @location.x = width
    end

    if @location.y > height
      @location.y = 0
    elsif @location.y < 0
      @location.y = height
    end
  end
end

# NOC_1_8_motion101_acceleration
def setup
  size(800, 200)
  @mover = Mover.new
end

def draw
  background(255)

  @mover.update
  @mover.check_edges
  @mover.display
end
