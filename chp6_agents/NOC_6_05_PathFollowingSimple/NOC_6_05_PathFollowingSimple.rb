# The Nature of Code
# NOC_6_05_PathFollowingSimple

class Path
  attr_reader :start, :finish, :radius
  def initialize(start, finish)
    @radius =20
    @start = start
    @finish = finish
  end

  def display
    stroke_weight(2*@radius)
    stroke(0, 100)
    line(@start.x, @start.y, @finish.x, @finish.y)

    stroke_weight(1)
    stroke(0)
    line(@start.x, @start.y, @finish.x, @finish.y)
  end
end

class Vehicle
  def initialize(loc, ms, mf)
    @location = loc.get
    @r = 4
    @maxspeed = ms
    @maxforce = mf
    @acceleration = PVector.new(0, 0)
    @velocity = PVector.new(@maxspeed, 0)
  end

  def run
    update
    display
  end

  def follow(path)
    #predict location 50 frames ahead
    predict = @velocity.get
    predict.normalize
    predict.mult(50)
    predict_loc = PVector.add(@location, predict)

    # look at the line segment
    a = path.start
    b = path.finish

    # get the normal point to that line
    normal_point = get_normal_point(predict_loc, a, b)

    dir = PVector.sub(b, a)
    dir.normalize
    dir.mult(10) # this could be based on velocity instead of arbitrary 10 pixels
    target = PVector.add(normal_point, dir)

    distance = PVector.dist(predict_loc, normal_point)

    seek(target) if distance > path.radius
  end

  def get_normal_point(p, a, b)
    ap = PVector.sub(p, a)
    ab = PVector.sub(b, a)
    ab.normalize

    # project vertor "diff" onto line by using the dot product
    ab.mult(ap.dot(ab))
    PVector.add(a, ab)
  end

  def update
    @velocity.add(@acceleration)
    @velocity.limit(@maxspeed)
    @location.add(@velocity)
    @acceleration.mult(0)
  end

  def apply_force(force)
    @acceleration.add(force)
  end

  def seek(target)
    desired = PVector.sub(target, @location)
    return if desired.mag == 0

    desired.normalize
    desired.mult(@maxspeed)

    steer = PVector.sub(desired, @velocity)
    steer.limit(@maxforce)

    apply_force(steer)
  end

  def display
    # draw a triangle rotated in the direction of the velocity
    theta = @velocity.heading2D + radians(90)
    fill(175)
    stroke(0)
    push_matrix
    translate(@location.x, @location.y)
    rotate(theta)
    begin_shape(PConstants.TRIANGLES)
    vertex(0, -@r*2)
    vertex(-@r, @r*2)
    vertex(@r, @r*2)
    end_shape
    pop_matrix
  end

  #wrap around
  def borders(path)
    if @location.x > path.finish.x + @r
      @location.x = path.start.x - @r
      @location.y = path.start.y + (@location.y - path.finish.y)
    end
  end
end

def setup
  size(640, 360)
  start = PVector.new(0, height/3)
  finish = PVector.new(width, 2*height/3)
  @path = Path.new(start, finish)
  @car1 = Vehicle.new(PVector.new(0, height/2), 2, 0.02)
  @car2 = Vehicle.new(PVector.new(0, height/2), 3, 0.05)
end

def draw
  background(255)
  @path.display
  @car1.follow(@path)
  @car2.follow(@path)

  @car1.run
  @car2.run

  @car1.borders(@path)
  @car2.borders(@path)
end
