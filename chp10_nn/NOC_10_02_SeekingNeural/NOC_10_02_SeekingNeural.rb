# The Nature of Code
# http://natureofcode.com

# Simple Perceptron Example
# See: http://en.wikipedia.org/wiki/Perceptron

class Perceptron
  # Perceptron is created with n weights and learning constant
  def initialize(n, c)
    @weights = Array.new(n){ random(0, 1) }
    @c = c
  end

  # Function to train the Perceptron
  # Weights are adjusted based on vehicle's error
  def train(forces, error)
    @weights.each_index do |i|
      @weights[i] += @c*error.x*forces[i].x
      @weights[i] += @c*error.y*forces[i].y
      @weights[i] = constrain(@weights[i], 0.to_f, 1.to_f)
    end
  end

  # Give me a steering result
  def feedforward(forces)
    # Sum all values
    sum = PVector.new
    @weights.each_index do |i|
      forces[i].mult(@weights[i])
      sum.add(forces[i])
    end
    sum
  end
end

# Seek
# Daniel Shiffman <http://www.shiffman.net>

class Vehicle

  def initialize(n, x, y)
    @brain = Perceptron.new(n, 0.001)
    @acceleration = PVector.new(0, 0)
    @velocity = PVector.new(0, 0)
    @location = PVector.new(x, y)
    @r = 3.0
    @maxspeed = 4
    @maxforce = 0.1
  end

  # Method to update location
  def update(width, height)
    # Update velocity
    @velocity.add(@acceleration)
    # Limit speed
    @velocity.limit(@maxspeed)
    @location.add(@velocity)
    # Reset accelerationelertion to 0 each cycle
    @acceleration.mult(0)

    @location.x = constrain(@location.x, 0, width)
    @location.y = constrain(@location.y, 0, height)
  end

  def apply_force(force)
    # We could add mass here if we want A = F / M
    @acceleration.add(force)
  end

  # Here is where the brain processes everything
  def steer(targets, desired)
    # Steer towards all targets
    forces = Array.new(targets.size){ |i| seek(targets[i]) }

    # That array of forces is the input to the brain
    result = @brain.feedforward(forces)

    # Use the result to steer the vehicle
    apply_force(result)

    # Train the brain according to the error
    error = PVector.sub(desired, @location)
    @brain.train(forces, error)
   end

  # A method that calculates a steering force towards a target
  # STEER = DESIRED MINUS VELOCITY
  def seek(target)
    desired = PVector.sub(target, @location)  # A vector pointing from the location to the target

    # Normalize desired and scale to maximum speed
    desired.normalize
    desired.mult(@maxspeed)
    # Steering = Desired minus velocity
    steer = PVector.sub(desired, @velocity)
    steer.limit(@maxforce)  # Limit to maximum steering force

    steer
  end

  def display

    # Draw a triangle rotated in the direction of velocity
    theta = @velocity.heading2D + PI/2
    fill(175)
    stroke(0)
    stroke_weight(1)
    push_matrix
    translate(@location.x, @location.y)
    rotate(theta)
    begin_shape
    vertex(0, -@r*2)
    vertex(-@r, @r*2)
    vertex(@r, @r*2)
    end_shape(CLOSE)
    pop_matrix
  end
end

# A Vehicle controlled by a Perceptron

def setup
  size(640, 360)
  # The Vehicle's desired location
  @desired = PVector.new(width/2, height/2)

  # Create a list of targets
  make_targets

  # Create the Vehicle (it has to know about the number of targets
  # in order to configure its brain)
  @v = Vehicle.new(@targets.size, random(width), random(height))
end

# Make a random ArrayList of targets to steer towards
def make_targets
  @targets = Array.new(8) { PVector.new(random(width), random(height)) }
end

def draw
  background(255)

  # Draw a circle to show the Vehicle's goal
  stroke(0)
  stroke_weight(2)
  fill(0, 100)
  ellipse(@desired.x, @desired.y, 36, 36)

  # Draw the targets
  @targets.each do |target|
    no_fill
    stroke(0)
    stroke_weight(2)
    ellipse(target.x, target.y, 16, 16)
    line(target.x, target.y-16, target.x, target.y+16)
    line(target.x-16, target.y, target.x+16, target.y)
  end

  # Update the Vehicle
  @v.steer(@targets, @desired)
  @v.update(width, height)
  @v.display
end

def mouse_pressed
  make_targets
end
