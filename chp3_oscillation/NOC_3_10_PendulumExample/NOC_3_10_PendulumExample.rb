# NOC_3_10_PendulumExample
# The Nature of Code
# http://natureofcode.com

# A Simple Pendulum Class
# Includes functionality for user can click and drag the pendulum
class Pendulum

  def initialize(origin_, r_)
    @origin = origin_.get
    @location = PVector.new
    @r = r_ # length of arm
    @angle = PI/4

    @aVelocity = 0.0
    @aAcceleration = 0.0
    @damping = 0.995   # Arbitrary damping
    @ballr = 48.0      # Arbitrary ball radius
    @dragging = false
  end

  def go
    update
    drag
    display
  end

  def update
    # As long as we aren't dragging the pendulum, let it swing!
    unless @dragging
      gravity = 0.4                              # Arbitrary constant
      @aAcceleration = (-1 * gravity / @r) * sin(@angle)  # Calculate acceleration (see: http://www.myphysicslab.com/pendulum1.html)
      @aVelocity += @aAcceleration                 # Increment velocity
      @aVelocity *= @damping                       # Arbitrary damping
      @angle += @aVelocity                         # Increment angle
    end
  end

  def display
    @location.set(@r*sin(@angle), @r*cos(@angle), 0)    # Polar to cartesian conversion
    @location.add(@origin)                              # Make sure the location is relative to the pendulum's origin

    stroke(0)
    stroke_weight(2)
    # Draw the arm
    line(@origin.x, @origin.y, @location.x, @location.y)
    ellipse_mode(CENTER)
    fill(175)
    fill(0) if @dragging
    # Draw the ball
    ellipse(@location.x, @location.y, @ballr, @ballr)
  end

  def clicked(mx, my)
    d = dist(mx, my, @location.x, @location.y)
    @dragging = true if d < @ballr
  end

  # This tells us we are not longer clicking on the ball
  def stop_dragging
    @aVelocity = 0 # No velocity once you let go
    @dragging = false
  end

  def drag
    # If we are draging the ball, we calculate the angle between the
    # pendulum origin and mouse location
    # we assign that angle to the pendulum
    if @dragging
      diff = PVector.sub(@origin, PVector.new(mouse_x, mouse_y))
      @angle = atan2(-1*diff.y, diff.x) - 90.radians   # Angle relative to vertical axis
    end
  end
end

# NOC_3_10_PendulumExample
def setup
  size(800, 200)
  # Make a new Pendulum with an origin location and armlength
  @p = Pendulum.new(PVector.new(width/2, 0), 175)
end

def draw
  background(255)
  @p.go
end

def mouse_pressed
  @p.clicked(mouse_x, mouse_y)
end

def mouse_released
  @p.stop_dragging
end
