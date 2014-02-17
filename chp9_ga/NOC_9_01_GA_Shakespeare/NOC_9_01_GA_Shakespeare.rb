# The Nature of Code
# http://natureofcode.com
# NOC_9_01_GA_Shakespeare

# Genetic Algorithm, Evolving Shakespeare

# A class to describe a psuedo-DNA, i.e. genotype
#   Here, a virtual organism's DNA is an array of character.
#   Functionality:
#      -- convert DNA into a string
#      -- calculate DNA's "fitness"
#      -- mate DNA with another set of DNA
#      -- mutate DNA


class DNA
  attr_reader :genes

  def initialize(num)
    @genes = Array.new(num) { random(32, 128).to_i.chr }
  end

  # Converts character array to a String
  def get_phrase
    @genes.join('')
  end

  # Fitness function (returns floating point % of "correct" characters)
  def fitness(target)
     score = 0
     @genes.each_index do |i|
      score += 1 if target[i] == @genes[i]
     end

     score / target.size.to_f
  end

  # Crossover
  def crossover(partner)
    # A new child
    child = DNA.new(@genes.size)

    midpoint = random(@genes.size).to_i # Pick a midpoint

    # Half from one, half from the other
    @genes.each_with_index do |c, i|
      if i > midpoint
        child.genes[i] = c
      else
        child.genes[i] = partner.genes[i]
      end
    end
    child
  end

  # Based on a mutation probability, picks a new random character
  def mutate(mutation_rate)
    @genes.map!{ |c| random(1) < mutation_rate ? random(32, 128).to_i.chr : c }
  end

  def to_s
    @genes.join('')
  end
end

# A class to describe a population of virtual organisms
# In this case, each organism is just an instance of a DNA object
class Population
  attr_reader :finished, :generations

  def initialize(p, m, num)
    @target = p
    @mutation_rate = m
    @population = Array.new(num) { DNA.new(@target.size) }
    calc_fitness
    @mating_pool = []
    @finished = false
    @generations = 0

    @perfect_score = 1
  end

  # Fill our fitness array with a value for every member of the population
  def calc_fitness
    @population.each do |p|
      p.fitness(@target)
    end
  end

  # Generate a mating pool
  def natural_selection
    # Clear the ArrayList
    @mating_pool.clear

    max_fitness = @population.max{|a, b| a.fitness(@target) <=> b.fitness(@target)}.fitness(@target)

    # Based on fitness, each member will get added to the mating pool a certain number of times
    # a higher fitness = more entries to mating pool = more likely to be picked as a parent
    # a lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    @population.each do |p|
      fitness = map(p.fitness(@target), 0, max_fitness, 0, 1)
      n = (fitness * 100).to_i      # Arbitrary multiplier, we can also use monte carlo method
      n.times{ @mating_pool << p }  # and pick two random numbers
    end
  end

  # Create a new generation
  def generate
    # Refill the population with children from the mating pool
    @population.each_index do |i|
      a = random(@mating_pool.size).to_i
      b = random(@mating_pool.size).to_i
      partner_a = @mating_pool[random(@mating_pool.size).to_i]
      partner_b = @mating_pool[random(@mating_pool.size).to_i]
      child = partner_a.crossover(partner_b)
      child.mutate(@mutation_rate)
      @population[i] = child
    end
    @generations += 1
  end


  # Compute the current "most fit" member of the population
  def get_best
    best = @population.max{|a, b| a.fitness(@target) <=> b.fitness(@target)}
    @finished = true if best.fitness(@target) == @perfect_score
    best.get_phrase
  end

  # Compute average fitness for the population
  def get_average_fitness
    sum = @population.inject(0){|sum, p| sum += p.fitness(@target) }
    sum / @population.size
  end

  def all_phrases
    display_limit = min(@population.size, 50)
    @population.first(display_limit).join("\n")
  end
end

# Genetic Algorithm, Evolving Shakespeare
# Demonstration of using a genetic algorithm to perform a search

# setup()
#  # Step 1: The Population
#    # Create an empty population (an array or ArrayList)
#    # Fill it with DNA encoded objects (pick random values to start)

# draw()
#  # Step 1: Selection
#    # Create an empty mating pool (an empty ArrayList)
#    # For every member of the population, evaluate its fitness based on some criteria / function,
#      and add it to the mating pool in a manner consistant with its fitness, i.e. the more fit it
#      is the more times it appears in the mating pool, in order to be more likely picked for reproduction.

#  # Step 2: Reproduction Create a new empty population
#    # Fill the new population by executing the following steps:
#       1. Pick two "parent" objects from the mating pool.
#       2. Crossover -- create a "child" object by mating these two parents.
#       3. Mutation -- mutate the child's DNA based on a given probability.
#       4. Add the child object to the new population.
#    # Replace the old population with the new population
#
#   # Rinse and repeat
def setup
  size(640, 360)
  @f = createFont("Courier", 32, true)
  @target = "To be or not to be."
  @popmax = 150
  @mutation_rate = 0.01

  # Create a populationation with a target phrase, mutation rate, and populationation max
  @population = Population.new(@target, @mutation_rate, @popmax)
end

def draw
  # Generate mating pool
  @population.natural_selection
  # Create next generation
  @population.generate
  # Calculate fitness
  @population.calc_fitness
  display_info

  # If we found the target phrase, stop
  if @population.finished
    println(millis/1000.to_f)
    no_loop
  end
end

def display_info
  background(255)
  # Display current status of populationation
  answer = @population.get_best
  text_font(@f)
  text_align(LEFT)
  fill(0)

  text_size(24)
  text("Best phrase:", 20, 30)
  text_size(40)
  text(answer, 20, 100)

  text_size(18)
  text("total generations:     #{@population.generations}", 20, 160)
  text("average fitness:       #{nf(@population.get_average_fitness, 0, 2)}", 20, 180)
  text("total population: #{@popmax}", 20, 200)
  text("mutation rate:         #{(@mutation_rate * 100).to_i}%", 20, 220)

  text_size(10)
  text("All phrases:\n #{@population.all_phrases}", 500, 10)
end
