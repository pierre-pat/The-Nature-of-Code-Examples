# The Nature of Code
# NOC_9_03_SmartRockets

# Pathfinding w/ Genetic Algorithms

# DNA is an array of vectors

class DNA
  attr_reader :genes
  # Constructor (makes a DNA of rand PVectors)
  def initialize(newgenes=nil)
    @maxforce = 0.1
    @lifetime = 300
    if newgenes
      @genes = newgenes
    else
      @genes = Array.new(@lifetime) do
        angle = rand(TWO_PI)
        gene = PVector.new(cos(angle), sin(angle))
        gene.mult(rand(0 ..  @maxforce))
        gene
      end
    end

    # Let's give each Rocket an extra boost of strength for its first frame
    @genes[0].normalize
  end

  # CROSSOVER
  # Creates new DNA sequence from two (this & and a partner)
  def crossover(partner)
    child = Array.new(@genes.size)
    # Pick a midpoint
    crossover = rand(genes.length).to_i
    # Take "half" from one and "half" from the other
    @genes.each_with_index do |g, i|
      if i > crossover
        child[i] = g
      else
        child[i] = partner.genes[i]
      end
    end
    DNA.new(child)
  end

  # Based on a mutation probability, picks a new rand Vector
  def mutate(m)
    @genes.each_with_index do |g, i|
      if rand(1) < m
        angle = rand(TWO_PI)
        @genes[i] = PVector.new(cos(angle), sin(angle))
        @genes[i].mult(rand(0 ..  @maxforce))
      end
    end
    @genes[0].normalize
  end
end

# A class for an obstacle, just a simple rectangle that is drawn
# and can check if a Rocket touches it
# Also using this class for target location
class Obstacle
  attr_reader :location
  def initialize(x, y, w_, h_)
    @location = PVector.new(x,y)
    @w = w_
    @h = h_
  end

  def display
    stroke(0)
    fill(175)
    strokeWeight(2)
    rect_mode(CORNER)
    rect(@location.x, @location.y, @w, @h)
  end

  def contains(spot)
    spot.x > @location.x && spot.x < @location.x + @w && spot.y > @location.y && spot.y < @location.y + @h
  end
end

# A class to describe a population of "creatures"
class Population
  attr_reader :generations

   def initialize(m, num, width, height)
    @mutation_rate = m
    @population = Array.new(num) do
      location = PVector.new(width/2,height+20)
      Rocket.new(location, DNA.new, num)
    end
    @mating_pool = []
    @generations = 0

    @width = width #don't want to keep these, but needed in the reproduction cycle
    @height = height
  end

  def live(obstacles, target)
    # For every creature
    @population.each do |p|
      p.check_target(target)
      p.run(obstacles)
    end
  end

  # Did anything finish?
  def target_reached
    @population.any?{ |p| p.hit_target }
  end

  # Calculate fitness for each creature
  def fitness
    @population.each{ |p| p.fitness }
  end

  # Generate a mating pool
  def selection
    # Clear the ArrayList
    @mating_pool.clear

    # Calculate total fitness of whole population
    max_fitness = @population.max{ |a, b| a.fitness <=> b.fitness }.fitness

    # Calculate fitness for each member of the population (scaled to value between 0 and 1)
    # Based on fitness, each member will get added to the mating pool a certain number of times
    # A higher fitness = more entries to mating pool = more likely to be picked as a parent
    # A lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    @population.each do |p|
      fitness_normal = map(p.fitness, 0, max_fitness, 0, 1)
      (fitness_normal * 100).to_i.times{ @mating_pool << p }
    end
  end

  # Making the next generation
  def reproduction
    # Refill the population with children from the mating pool
    @population.each_with_index do |p, i|
      # Sping the wheel of fortune to pick two parents
      m = rand(@mating_pool.size).to_i
      d = rand(@mating_pool.size).to_i
      # Pick two parents
      mom = @mating_pool[m]
      dad = @mating_pool[d]
      # Get their genes
      momgenes = mom.dna
      dadgenes = dad.dna
      # Mate their genes
      child = momgenes.crossover(dadgenes)
      # Mutate their genes
      child.mutate(@mutation_rate)
      # Fill the new population with the new child
      location = PVector.new(@width/2, @height+20)
      @population[i] = Rocket.new(location, child, @population.size)
    end
    @generations += 1
  end
end

# Rocket class -- this is just like our Boid / Particle class
# the only difference is that it has DNA & fitness

class Rocket
  attr_reader :fitness, :dna, :hit_target

  def initialize(l, dna_, total_rockets)
    @acceleration = PVector.new
    @velocity = PVector.new
    @location = l.get
    @r = 4
    @dna = dna_
    @finish_time = 0;     # We're going to count how long it takes to reach target
    @record_dist = 10000   #  Some high number that will be beat instantly
    @gene_counter = 0
    @hit_obstacle = false
    @hit_target = false
  end

  # FITNESS FUNCTION
  # distance = distance from target
  # finish = what order did i finish (first, second, etc. . .)
  # f(distance,finish) =   (1.0f / finish^1.5) * (1.0f / distance^6);
  # a lower finish is rewarded (exponentially) and/or shorter distance to target (exponetially)
  def fitness
    @record_dist = 1 if @record_dist < 1

    # Reward finishing faster and getting close
    @fitness = (1/(@finish_time*@record_dist))

    # Make the function exponential
    @fitness = @fitness**4

    @fitness *= 0.1 if @hit_obstacle # lose 90% of fitness hitting an obstacle
    @fitness *= 2 if @hit_target     # twice the fitness for finishing!
    @fitness
  end

  # Run in relation to all the obstacles
  # If I'm stuck, don't bother updating or checking for intersection
  def run(obstacles)
    unless @hit_obstacle or @hit_target
      apply_force(@dna.genes[@gene_counter])
      @gene_counter = (@gene_counter + 1) % @dna.genes.size
      update
      # If I hit an edge or an obstacle
      obstacles(obstacles)
    end
    # Draw me
    display unless @hit_obstacle
  end

  # Did I make it to the target?
  def check_target(target)
    d = dist(@location.x, @location.y, target.location.x, target.location.y)
    @record_dist = d if d < @record_dist

    if target.contains(@location) and not @hit_target
      @hit_target = true
    elsif not @hit_target
      @finish_time += 1
    end
  end

  # Did I hit an obstacle?
  def obstacles(obstacles)
    obstacles.each{ |o| @hit_obstacle = true if o.contains(@location) }
  end

  def apply_force(f)
    @acceleration.add(f)
  end

  def update
    @velocity.add(@acceleration)
    @location.add(@velocity)
    @acceleration.mult(0)
  end

  def display
    #background(255,0,0);
    theta = @velocity.heading2D + PI/2
    fill(200, 100)
    stroke(0)
    stroke_weight(1)
    push_matrix
    translate(@location.x, @location.y)
    rotate(theta)

    # Thrusters
    rectMode(CENTER)
    fill(0)
    rect(-@r/2, @r*2, @r/2, @r)
    rect(@r/2, @r*2, @r/2, @r)

    # Rocket body
    fill(175)
    begin_shape(TRIANGLES)
    vertex(0, -@r*2)
    vertex(-@r, @r*2)
    vertex(@r, @r*2)
    end_shape

    pop_matrix
  end

  def stopped
    @hit_obstacle
  end
end

# Each Rocket's DNA is an array of PVectors
# Each PVector acts as a force for each frame of animation
# Imagine an booster on the end of the rocket that can point in any direction
# and fire at any strength every frame

# The Rocket's fitness is a function of how close it gets to the target as well as how fast it gets there

# This example is inspired by Jer Thorp's Smart Rockets
# http://www.blprnt.com/smartrockets/

def setup
  size(640, 360)
  # The number of cycles we will allow a generation to live
  @lifetime = 300

  # Initialize variables
  @lifecycle = 0
  @recordtime = @lifetime

  @target = Obstacle.new(width/2-12, 24, 24, 24)

  # Create a population with a mutation rate, and population max
  @mutation_rate = 0.01
  @population = Population.new(@mutation_rate, 50, width, height)

  # Create the obstacle course
  @obstacles = []
  @obstacles << Obstacle.new(width/2-100, height/2, 200, 10)
end

def draw
  background(255)

  # Draw the start and target locations
  @target.display


  # If the generation hasn't ended yet
  if @lifecycle < @lifetime
    @population.live(@obstacles, @target)
    @recordtime = @lifecycle if @population.target_reached and @lifecycle < @recordtime

    @lifecycle += 1
  else # Otherwise a new generation
    @lifecycle = 0
    @population.fitness
    @population.selection
    @population.reproduction
  end

  # Draw the obstacles
  @obstacles.each{ |o| o.display }

  # Display some info
  fill(0)
  text("Generation #: #{@population.generations}", 10, 18)
  text("Cycles left: #{@lifetime-@lifecycle}", 10, 36)
  text("Record cycles: #{@recordtime}", 10, 54)
end

# Move the target if the mouse is pressed
# System will adapt to new target
def mouse_pressed
  @target.location.x = mouse_x
  @target.location.y = mouse_y
  @recordtime = @lifetime
end
