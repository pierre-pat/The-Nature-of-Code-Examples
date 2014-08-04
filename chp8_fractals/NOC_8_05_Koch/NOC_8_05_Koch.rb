# The Nature of Code
# NOC_8_05_Koch
class KochLine
  def initialize(start, finish)
    @a = start.get
    @b = finish.get
  end

  def display
    stroke(120)
    line(@a.x, @a.y, @b.x, @b.y)
  end

  # This is easy, just 1/3 of the way
  def kochleft
    v = PVector.sub(@b, @a)
    v.div(3)
    v.add(@a)
    v
  end

  # More complicated, have to use a little trig to figure out where this PVector is!
  def kochmiddle
    v = PVector.sub(@b, @a)
    v.div(3)

    p = @a.get
    p.add(v)

    rotate_line(v,-60.radians)
    p.add(v)
    p
  end

  # Easy, just 2/3 of the way
  def kochright
    v = PVector.sub(@a, @b)
    v.div(3)
    v.add(@b)
    v
  end

  def start; @a.get; end;
  def finish; @b.get; end;

  private
  def rotate_line(v, theta)
    xtemp = v.x
    # Might need to check for rounding errors like with angleBetween function?
    v.x = v.x*cos(theta) - v.y*sin(theta)
    v.y = xtemp*sin(theta) + v.y*cos(theta)
  end
end

class KochFractal
  attr_reader :count
  def initialize(width, height)
    @start = PVector.new(0, height-20)
    @finish = PVector.new(width, height-20)
    @lines = []
    restart
  end

  def next_level
    # For every line that is in the arraylist
    # create 4 more lines in a new arraylist
    @lines = iterate(@lines)
    @count += 1
  end

  def restart
    @count = 0      # Reset count
    @lines.clear  # Empty the array list
    @lines << KochLine.new(@start, @finish)  # Add the initial line (from one end PVector to the other)
  end

  def render
    @lines.each{ |line| line.display }
  end

  # This is where the **MAGIC** happens
  # Step 1: Create an empty arraylist
  # Step 2: For every line currently in the arraylist
  #   - calculate 4 line segments based on Koch algorithm
  #   - add all 4 line segments into the new arraylist
  # Step 3: Return the new arraylist and it becomes the list of line segments for the structure

  # As we do this over and over again, each line gets broken into 4 lines, which gets broken into 4 lines, and so on. . .
  def iterate(before)
    now = []    # Create emtpy list
    before.each do |l|
      # Calculate 5 koch PVectors (done for us by the line object)
      a = l.start
      b = l.kochleft
      c = l.kochmiddle
      d = l.kochright
      e = l.finish
      # Make line segments between all the PVectors and add them
      now << KochLine.new(a,b)
      now << KochLine.new(b,c)
      now << KochLine.new(c,d)
      now << KochLine.new(d,e)
    end
    now
  end
end

def setup
  size(800, 250)
  background(255)
  frameRate(1)  # Animate slowly
  @k = KochFractal.new(width, height)
  smooth
end

def draw
  background(255)
  # Draws the snowflake!
  @k.render
  # Iterate
  @k.next_level
  # Let's not do it more than 5 times. . .
  @k.restart if @k.count > 5
end
