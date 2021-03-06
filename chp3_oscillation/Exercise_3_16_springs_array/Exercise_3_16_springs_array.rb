# Exercise_3_16_springs_array
class Bob
  attr_reader :location

  def initialize(x, y)
    @location = PVector.new(x,y)
    @velocity = PVector.new
    @acceleration = PVector.new
    @drag_offset = PVector.new
    @dragging = false
    @damping = 0.95 # Arbitrary damping to simulate friction / drag
    @mass = 12
  end

  # Standard Euler integration
  def update
    @velocity.add(@acceleration)
    @velocity.mult(@damping)
    @location.add(@velocity)
    @acceleration.mult(0)
  end

  # Newton's law: F = M * A
  def apply_force(force)
    f = force.get
    f.div(@mass)
    @acceleration.add(f)
  end

  # Draw the bob
  def display
    stroke(0)
    stroke_weight(2)
    fill(175)
    fill(50) if @dragging
    ellipse(@location.x, @location.y, @mass*2, @mass*2)
  end

  # This checks to see if we clicked on the mover
  def clicked(mx, my)
    d = dist(mx, my, @location.x, @location.y)
    if d < @mass
      @dragging = true
      @drag_offset.x = @location.x-mx
      @drag_offset.y = @location.y-my
    end
  end

  def stop_dragging
    @dragging = false
  end

  def drag(mx, my)
    if @dragging
      @location.x = mx + @drag_offset.x
      @location.y = my + @drag_offset.y
    end
  end
end

class Spring

  def initialize(a, b, l)
    @bob_a = a
    @bob_b = b
    @len = l
    @k = 0.2
  end

  # Calculate spring force
  def update
    # Vector pointing from anchor to bob location
    force = PVector.sub(@bob_a.location, @bob_b.location)
    # What is distance
    d = force.mag
    # Stretch is difference between current distance and rest length
    stretch = d - @len

    # Calculate force according to Hooke's Law
    # F = k * stretch
    force.normalize
    force.mult(-1 * @k * stretch)
    @bob_a.apply_force(force)
    force.mult(-1)
    @bob_b.apply_force(force)
  end

  def display
    stroke_weight(2)
    stroke(0)
    line(@bob_a.location.x, @bob_a.location.y, @bob_b.location.x, @bob_b.location.y)
  end
end

# Exercise_3_16_springs_array
def setup
  size(640, 360)
  # Create objects at starting location
  # Note third argument in Spring constructor is "rest length"
  @bobs = Array.new(5) { |i| Bob.new(width/2, i*40) }
  @springs = Array.new(4) { |i| Spring.new(@bobs[i], @bobs[i+1], 40) }
end

def draw
  background(255)

  @springs.each do |s|
    s.update
    s.display
  end

  @bobs.each do |b|
    b.update
    b.display
    b.drag(mouse_x, mouse_y)
  end
end

def mouse_pressed
  @bobs.each{ |b| b.clicked(mouse_x, mouse_y) }
end

def mouse_released
  @bobs.each{ |b| b.stop_dragging }
end
