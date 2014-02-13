# The Nature of Code
# http://natureofcode.com

# Evolution EcoSystem

# Creature class

class Bloop

  def initialize(loc, dna)
    @location = loc.get
    @health = 200
    @xoff = rand(1000)
    @yoff = rand(1000)
    @dna = dna
    @maxspeed = $app.map(@dna.genes[0], 0, 1, 15, 0)
    @r = $app.map(@dna.genes[0], 0, 1, 0, 50)
  end

  def run
    update
    borders($app.width, $app.height)
    display
  end

  def eat(f)
    food = f.food

    food.delete_if do |food_loc|
      d = PVector.dist(@location, food_loc)
      if d < @r/2
        @health += 100
        true
      end
    end
  end

  def reproduce
    if rand < 0.0005
      childDNA = @dna.copy
      childDNA.mutate(0.01)
      return Bloop.new(@location, childDNA)
    end
  end

  def update
    vx = $app.map($app.noise(@xoff), 0, 1, -@maxspeed, @maxspeed)
    vy = $app.map($app.noise(@yoff), 0, 1, -@maxspeed, @maxspeed)
    velocity = PVector.new(vx, vy)
    @xoff += 0.01
    @yoff += 0.01
    @location.add(velocity)
    @health -= 0.2
  end

  def borders(width, height)
    @location.x = width + @r if @location.x < -@r
    @location.y = height + @r if @location.y < -@r
    @location.x = -@r if @location.x > width + @r
    @location.y = -@r if @location.y > height + @r
  end

  def display
    $app.stroke(0, @health)
    $app.fill(0, @health)
    $app.ellipse(@location.x, @location.y, @r, @r)
  end

  def dead?
    @health < 0
  end
end
