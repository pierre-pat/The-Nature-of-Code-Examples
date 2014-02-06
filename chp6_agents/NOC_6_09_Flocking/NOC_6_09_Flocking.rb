# The Nature of Code
# NOC_6_09_Flocking
class Boid
  attr_reader :location, :velocity
  def initialize(x, y)
    @acceleration = PVector.new
    @velocity = PVector.new(random(-1, -1), random(-1, -1))
    @location = PVector.new(x, y)
    @r = 3
    @maxspeed = 3
    @maxforce = 0.05
  end

  def run(boids, width, height)
    flock(boids)
    update
    borders(width, height)
    render
  end

  def apply_force(force)
    @acceleration.add(force)
  end

  def flock(boids)
    sep = separate(boids)
    ali = align(boids)
    coh = cohesion(boids)

    sep.mult(1.5)

    apply_force(sep)
    apply_force(ali)
    apply_force(coh)
  end

  def seek(target)
    desired = PVector.sub(target, @location)
    return if desired.mag == 0

    desired.normalize
    desired.mult(@maxspeed)

    steer = PVector.sub(desired, @velocity)
    steer.limit(@maxforce)

    steer
  end

  def separate(vehicles)
    desired_separation = @r*2
    sum = PVector.new
    count = 0

    vehicles.each do |other|
      d = PVector.dist(@location, other.location)
      if d > 0 and d < desired_separation
        diff = PVector.sub(@location, other.location)
        diff.normalize
        diff.div(d)
        sum.add(diff)
        count += 1
      end
    end

    if count > 0
      sum.div(count)
      sum.normalize
      sum.mult(@maxspeed)
      steer = PVector.add(sum, @velocity)
      steer.limit(@maxforce)
      apply_force(steer)
    end

    sum
  end

  def align(boids)
    neighbordist = 50
    sum = PVector.new
    count = 0
    boids.each do |other|
      d = PVector.dist(@location, other.location)
      if d > 0 and d < neighbordist
        sum.add(other.velocity)
        count += 1
      end
    end

    if count > 0
      sum.div(count)
      sum.normalize
      sum.mult(@maxspeed)
      steer = PVector.sub(sum, @velocity)
      steer.limit(@maxforce)
      return steer
    else
      return PVector.new
    end
  end

  def cohesion(boids)
    neighbordist = 50
    sum = PVector.new
    count = 0
    boids.each do |other|
      d = PVector.dist(@location, other.location)
      if d > 0 and d < neighbordist
        sum.add(other.location)
        count += 1
      end
    end

    if count > 0
      sum.div(count)
      return seek(sum)
    else
      return PVector.new
    end
  end

  def update
    @velocity.add(@acceleration)
    @velocity.limit(@maxspeed)
    @location.add(@velocity)
    @acceleration.mult(0)
  end

  def render
    theta = @velocity.heading2D + radians(90)
    fill(175)
    stroke(0)
    push_matrix
    translate(@location.x, @location.y)
    rotate(theta)
    begin_shape(TRIANGLES)
    vertex(0, -@r*2)
    vertex(-@r, @r*2)
    vertex(@r, @r*2)
    end_shape
    pop_matrix
  end

  def borders(width, height)
    @location.x = width + @r if @location.x < -@r
    @location.y = height + @r if @location.y < -@r
    @location.x = -@r if @location.x > width + @r
    @location.y = -@r if @location.y < -@r
  end
end

class Flock
  def initialize
    @boids = []
  end

  def run(width, height)
    @boids.each {|b| b.run(@boids, width, height) }
  end

  def add_boid(b)
    @boids << b
  end
end

def setup
  size(640, 360)
  @flock = Flock.new
  200.times { @flock.add_boid(Boid.new(width/2, height/2)) }
  smooth
end

def draw
  background(255)
  @flock.run(width, height)
end

def mouse_dragged
  @flock.add_boid(Boid.new(mouse_x, mouse_y))
end
