# Exercise_2_10_attractrepel
# The Nature of Code
# http://natureofcode.com
# A class for a draggable attractive body in our world
G = 1

class Attractor

  def initialize(width, height)
    @location = PVector.new(width/2, height/2)
    @mass = 10
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
    stroke(0)
    if @dragging
      fill (50)
    elsif @rollover
      fill(100)
    else
      fill(0)
    end
    ellipse(@location.x, @location.y, @mass*6, @mass*6)
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

# The Nature of Code
# http://natureofcode.com

class Mover
  attr_reader :location, :mass

  def initialize(m, x , y)
    @mass = m;
    @location = PVector.new(x,y)
    @velocity = PVector.new(0,0)
    @acceleration = PVector.new(0,0)
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
    fill(175, 200)
    ellipse(@location.x, @location.y, @mass*2, @mass*2)
  end

  def repel(mover)
    force = PVector.sub(@location, mover.location)   # Calculate direction of force
    distance = force.mag                             # Distance between objects
    distance = constrain(distance, 1.0,10000.0)      # Limiting the distance to eliminate "extreme" results for very close or very far objects
    force.normalize                                  # Normalize vector (distance doesn't matter here, we just want this vector for direction

    strength = (G * @mass * mover.mass) / (distance * distance) # Calculate gravitional force magnitude
    force.mult(-strength)                                   # Get force vector --> magnitude * direction
    force
  end

  def check_edges
    if @location.x > width
      @location.x = width
      @velocity.x *= -1
    elsif @location.x < 0
      @location.x = 0
      @velocity.x *= -1
    end

    if @location.y > height
      @location.y = height
      @velocity.y *= -1
    elsif @location.y < 0
      @location.y = 0
      @velocity.y *= -1
    end
  end
end

# Exercise_2_10_attractrepel
# The Nature of Code
# http://natureofcode.com

def setup
  size(800, 200)
  @attractor = Attractor.new(width, height)
  @movers = Array.new(20) { Mover.new(random(4, 12), random(width), random(height)) }
end

def draw
  background(255)

  @attractor.display

  @movers.each do |m|
    @movers.each do |mm|
      unless m == mm
        force = mm.repel(m)
        m.apply_force(force)
      end
    end

    force = @attractor.attract(m)
    m.apply_force(force)
    m.update
    m.display
  end
end
