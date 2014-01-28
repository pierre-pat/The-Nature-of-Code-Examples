# The Nature of Code
# http://natureofcode.com

class CannonBall
  attr_reader :location

  def initialize(x, y)
    @location = PVector.new(x, y)
    @velocity = PVector.new
    @acceleration = PVector.new
    @topspeed = 10
    @r = 8
  end

  # Standard Euler integration
  def update
    @velocity.add(@acceleration)
    @velocity.limit(@topspeed)
    @location.add(@velocity)
    @acceleration.mult(0)
  end

  def apply_force(force)
    @acceleration.add(force)
  end


  def display
    stroke(0)
    stroke_weight(2)
    push_matrix()
    translate(@location.x, @location.y)
    ellipse(0, 0, @r*2, @r*2)
    pop_matrix
  end
end

def setup
  size(640, 360)

  # All of this stuff should go into a Cannon class
  @angle = -PI/4
  @location = PVector.new(50, 300)
  @shot = false

  @ball = CannonBall.new(@location.x, @location.y)
end

def draw
  background(255)

  push_matrix
  translate(@location.x, @location.y)
  rotate(@angle)
  rect(0, -5, 50, 10)
  pop_matrix

  if @shot
    gravity = PVector.new(0, 0.2)
    @ball.apply_force(gravity)
    @ball.update
  end
  @ball.display

  if @ball.location.y > height or @ball.location.x > width
    @ball = CannonBall.new(@location.x, @location.y)
    @shot = false
  end
end

def key_pressed
  if key == CODED and key_code == RIGHT
    @angle += 0.1
  elsif key == CODED and key_code == LEFT
    @angle -= 0.1
  elsif key == ' '
    @shot = true
    force = PVector.new(Math.cos(@angle), Math.sin(@angle))
    force.mult(10)
    @ball.apply_force(force)
  end
end
