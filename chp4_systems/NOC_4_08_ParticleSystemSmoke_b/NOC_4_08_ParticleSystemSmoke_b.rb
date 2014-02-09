# NOC_4_08_ParticleSystemSmoke_b
# The Nature of Code
# http://natureofcode.com

class Particle
  def initialize(loc, vel, img)
    @loc = loc.get
    @img = img
    @vel = vel
    @acc = PVector.new
    @lifespan = 100
  end

  def run
    update
    render
  end

  def apply_force(force)
    @acc.add(force)
  end

  def update
    @vel.add(@acc)
    @loc.add(@vel)
    @lifespan -= 2.5
    @acc.mult(0)
  end

  def render
    image_mode(CENTER)
    tint(255, @lifespan)
    image(@img, @loc.x, @loc.y)
    # Drawing a circle instead
    # fill(255, @lifespan)
    # no_stroke
    # ellipse(@loc.x, @loc.y, 10, 10)
  end

  def is_dead?
    @lifespan <= 0.0
  end
end

import java.util.Random
class ParticleSystem
  def initialize(num, origin, img)
    @origin = origin.get
    @img = img
    @generator = Random.new
    @particles = Array.new(num) { create_particle }
  end

  def add_particle(particle=nil)
    particle ||= create_particle
    @particles << particle
  end

  def apply_force(f)
    @particles.each{|p| p.apply_force(f)}
  end

  def run
    @particles.each{ |p| p.run }
    @particles.delete_if{ |p| p.is_dead? }
  end

  def is_dead?
    @particles.empty?
  end

  private
  def create_particle
    vx = @generator.next_gaussian * 0.3
    vy = @generator.next_gaussian * 0.3 - 1
    vel = PVector.new(vx, vy)
    Particle.new(@origin, vel, @img)
  end
end

def setup
  size(640, 360)
  img = load_image("#{Dir.pwd}/data/texture.png")
  @ps = ParticleSystem.new(0, PVector.new(width/2,height-75), img)
  smooth
end

def draw
  background(0)

  # Calculate a "wind" force based on mouse horizontal position
  dx = map(mouse_x, 0, width, -0.2, 0.2)
  wind = PVector.new(dx, 0)
  @ps.apply_force(wind)
  @ps.run
  2.times{ @ps.add_particle }

  # Draw an arrow representing the wind force
  draw_vector(wind, PVector.new(width/2, 50), 500)
end

# Renders a vector object 'v' as an arrow and a location 'loc'
def draw_vector(v, loc, scayl)
  push_matrix
  arrowsize = 4
  # Translate to location to render vector
  translate(loc.x, loc.y)
  stroke(255)
  # Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
  rotate(v.heading2D)
  # Calculate length of vector & scale it to be bigger or smaller if necessary
  len = v.mag * scayl
  # Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
  line(0, 0, len, 0)
  line(len, 0, len-arrowsize, +arrowsize/2)
  line(len, 0, len-arrowsize, -arrowsize/2)
  pop_matrix
end
