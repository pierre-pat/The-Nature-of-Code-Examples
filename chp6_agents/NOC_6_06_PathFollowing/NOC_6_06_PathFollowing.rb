# The Nature of Code
# NOC_6_06_PathFollowing

class Path
  attr_reader :points, :radius
  def initialize
    @radius = 20
    @points = []
  end

  def add_point(x, y)
    @points << PVector.new(x, y)
  end

  def get_start
    @points[0]
  end

  def get_end
    @points[-1]
  end

  def display

    draw = Proc.new do |color, weight|
      stroke(color)
      stroke_weight(weight)
      no_fill
      begin_shape
      @points.each{|v| vertex(v.x, v.y)}
      end_shape
    end

    draw.call(175, @radius*2) # draw thick line with radius
    draw.call(0, 1) # draw thing middle line

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

    worldrecord = 100000 # far away
    target = nil
    normal = nil

    (0...path.points.size-1).each do |i|
      a = path.points[i]
      b = path.points[i+1]

      normal_point = get_normal_point(predict_loc, a, b)
      normal_point = b.get if normal_point.x < a.x || normal_point.x > b.x

      distance = PVector.dist(predict_loc, normal_point)

      if distance < worldrecord
        worldrecord = distance
        normal = normal_point

        dir = PVector.sub(b, a)
        dir.normalize

        dir.mult(10)
        target = normal_point.get
        target.add(dir)
      end
    end

    seek(target) if worldrecord > path.radius
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
    theta = @velocity.heading2D + 90.radians
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
    if @location.x > path.get_end.x + @r
      @location.x = path.get_start.x - @r
      @location.y = path.get_start.y + (@location.y - path.get_end.y)
    end
  end
end

def setup
  size(640, 360)
  start = PVector.new(0, height/3)
  finish = PVector.new(width, 2*height/3)
  new_path
  @car1 = Vehicle.new(PVector.new(0, height/2), 2, 0.04)
  @car2 = Vehicle.new(PVector.new(0, height/2), 3, 0.1)
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

def new_path
  @path = Path.new
  @path.add_point(-20, height/2)
  @path.add_point(rand(0 ..  width/2), rand(0 ..  height))
  @path.add_point(rand(width / 2 ..  width), rand(0 ..  height))
  @path.add_point(width+20, height/2)
end

def mouse_pressed
  new_path
end
