# Extra_instantforce
# The Nature of Code
# http://natureofcode.com

class Mover

  attr_reader :location

  def initialize(width, height)
    @location = PVector.new(width/2, height/2)
    @velocity = PVector.new(0, 0)
    @acceleration = PVector.new(0, 0)
    @mass = 1
  end

  def shake
     force = PVector.new(rand, rand)
     force.mult(0.7)
     apply_force(force)
  end

  def apply_force(force)
    f = PVector.div(force, @mass)
    @acceleration.add(f)
  end

  def update
    @velocity.add(@acceleration)
    @location.add(@velocity)
    @acceleration.mult(0)

    # Simple friction
    @velocity.mult(0.95)
  end

  def display
    stroke(0)
    stroke_weight(2)
    fill(127)
    ellipse(@location.x, @location.y, 48, 48)
  end

  def check_edges(width, height)
    if @location.x > width
      @location.x = width
      @velocity.x *= -1
    elsif @location.x < 0
      @velocity.x *= -1
      @location.x = 0
    end

    if @location.y > height
      @velocity.y *= -1
      @location.y = height
    end
  end
end

# Extra_instantforce
# The Nature of Code
# http://natureofcode.com

def setup
  size(640, 360)
  @mover = Mover.new(width, height)
  @t = 0.0
end

def draw
  background(255)

  # Perlin noise wind
  wx = map(noise(@t), 0, 1, -1, 1)
  wind = PVector.new(wx, 0)
  @t += 0.01
  line(width/2, height/2, width/2+wind.x*100, height/2+wind.y*100)
  @mover.apply_force(wind)

  # Gravity
  gravity = PVector.new(0, 0.1)
  #@mover.apply_force(gravity)

  # Shake force
  #@mover.shake

  # Boundary force
  if @mover.location.x > width - 50
    boundary = PVector.new(-1, 0)
    @mover.apply_force(boundary)
  elsif @mover.location.x < 50
    boundary = PVector.new(1, 0)
    @mover.apply_force(boundary)
  end

  @mover.update
  @mover.display
  #@mover.check_edges(width, height)
end

# Instant Force
def mouse_pressed
  cannon = PVector.new(rand, rand)
  cannon.mult(5)
  @mover.apply_force(cannon)
end
