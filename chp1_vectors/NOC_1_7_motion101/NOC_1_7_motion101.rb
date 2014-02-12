# The Nature of Code
# http://natureofcode.com

class Mover

  def initialize(width, height)
    @location = PVector.new(rand(width/2), rand(height/2))
    @velocity = PVector.new(random(-2, 2), random(-2, 2))
  end

  def update
    @location.add(@velocity)
  end

  def display
    stroke(0)
    stroke_weight(2)
    fill(127)
    ellipse(@location.x, @location.y, 48, 48)
  end

  def check_edges(width, height)
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

# NOC_1_7_motion101
def setup
  size(800, 200)
  @mover = Mover.new(width, height)
end

def draw
  background(255)

  @mover.update
  @mover.check_edges(width, height)
  @mover.display
end
