# NOC_3_03_pointing_velocity
# http://natureofcode.com
class Mover
  attr_reader :location, :mass

  def initialize
    @location = PVector.new(width/2, height/2)
    @velocity = PVector.new(0, 0)
    @topspeed = 4
    @xoff = 1000
    @yoff = 0
  end

  def update
    mouse = PVector.new(mouse_x, mouse_y)
    dir = PVector.sub(mouse, @location)
    dir.normalize
    dir.mult(0.5)

    @velocity.add(dir)
    @velocity.limit(@topspeed)
    @location.add(@velocity)
  end

  def display
    theta = -1 * Math.atan2(-@location.y, @location.x)

    stroke(0)
    stroke_weight(2)
    fill(127)
    push_matrix
    rect_mode(CENTER)
    translate(@location.x, @location.y)
    rotate(theta)
    rect(0, 0, 30, 10)
    pop_matrix
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

# NOC_3_03_pointing_velocity
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
