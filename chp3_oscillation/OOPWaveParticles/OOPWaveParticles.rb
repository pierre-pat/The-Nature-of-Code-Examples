# OOPWaveParticles
# The Nature of Code
# http://natureofcode.com

class Particle

  def initialize
    @location = PVector.new
  end

  def set_location(x, y)
    @location.x = x
    @location.y = y
  end

  def display
    fill(random(255))
    ellipse(@location.x, @location.y, 16, 16)
  end
end

class Wave

  def initialize(o, w_, a, p)
    @origin = o.get
    @w = w_
    @period = p
    @amplitude = a
    @xspacing = 8
    @dx = (TWO_PI / @period) * @xspacing
    @theta = 0.0
    @particles = Array.new(@w/@xspacing){ Particle.new }
  end

  def calculate
    # Increment theta (try different values for 'angular velocity' here
    @theta += 0.02

    # For every x value, calculate a y value with sine function
    x = @theta
    @particles.each_index do |i|
      @particles[i].set_location(@origin.x+i*@xspacing, @origin.y+sin(x)*@amplitude)
      x += @dx
    end
  end

  def display
    # A simple way to draw the wave with an ellipse at each location
    @particles.each{ |p| p.display }
  end
end

def setup
  size(640, 360)
  # Initialize a wave with starting point, width, amplitude, and period
  @wave0 = Wave.new(PVector.new(200, 75), 100, 20, 500)
  @wave1 = Wave.new(PVector.new(150, 250), 300, 40, 220)
end

def draw
  background(255)

  # Update and display waves
  @wave0.calculate
  @wave0.display

  @wave1.calculate
  @wave1.display
end
