#  NOC_2_6_attraction
# The Nature of Code
# http://natureofcode.com
# A class for a draggable attractive body in our world

class Attractor
  G = 1

  def initialize(width, height)
    @location = PVector.new(width/2, height/2)
    @mass = 20
    @drag_offset = PVector.new(0.0, 0.0)
    @dragging = false
    @rollover = false
  end

  def attract(mover)
    force = PVector.sub(@location, mover.location) # Calculate direction of force
    d = force.mag                                  # Distance between objects
    d = constrain(d, 5.0, 25.0)                    # Limiting the distance to eliminate "extreme" results for very close or very far objects
    force.normalize                                # Normalize vector (distance doesn't matter here, we just want this vector for direction)
    strength = (G * @mass * mover.mass) / (d * d)  # Calculate gravitional force magnitude
    force.mult(strength)                           # Get force vector --> magnitude * direction
    force
  end

  def display
    ellipse_mode(CENTER)
    stroke_weight(4)
    stroke(0)
    if @dragging
      fill (50)
    elsif @rollover
      fill(100)
    else
      fill(175, 200)
    end
    ellipse(@location.x, @location.y, @mass*2, @mass*2)
  end

  # The methods below are for mouse interaction
  def clicked(mx, my)
    d = dist(mx ,my, @location.x, @location.y)
    if d < @mass
      @dragging = true;
      @drag_offset.x = @location.x-mx
      @drag_offset.y = @location.y-my
    end
  end

  def hover(mx, my)
    d = dist(mx, my, @location.x, @location.y)
    @rollover = d < @mass
  end

  def stop_dragging
    @dragging = false
  end

  def drag
    if @dragging
      @location.x = mouse_x + @drag_offset.x
      @location.y = mouse_y + @drag_offset.y
    end
  end
end

class Mover
  attr_reader :mass, :velocity, :location
  def initialize
    @location = PVector.new(400, 50)
    @velocity = PVector.new(1, 0)
    @acceleration = PVector.new(0, 0)
    @mass = 1
  end

  def apply_force(force)
    f = PVector.div(force, @mass)
    @acceleration.add(f)
  end

  def update
    @velocity.add(@acceleration)
    @location.add(@velocity)

    @acceleration.mult(0)
  end

  def display
    stroke(0)
    stroke_weight(2)
    fill(127)
    ellipse(@location.x, @location.y, @mass*16, @mass*16)
  end

  def check_edges(width, height)
    if @location.x > width
      @location.x = 0
    elsif @location.x < 0
      @location.x = width
    end

    if @location.y > height
      @location.y = height
      @velocity.y *= -1
    end
  end
end


# NOC_2_6_attraction
def setup
  size(640, 360)
  @mover =  Mover.new
  @attractor = Attractor.new(width, height)
end

def draw
  background(255)

  force = @attractor.attract(@mover)
  @mover.apply_force(force)
  @mover.update

  @attractor.drag
  @attractor.hover(mouse_x, mouse_y)

  @attractor.display
  @mover.display
end

def mousePressed
  @attractor.clicked(mouse_x, mouse_y)
end

def mouseReleased
  @attractor.stop_dragging
end
