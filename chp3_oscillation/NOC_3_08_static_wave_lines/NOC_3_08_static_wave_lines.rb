# NOC_3_08_static_wave_lines
# The Nature of Code
# http://natureofcode.com

angle = 0
angle_vel = 0.1

size(800, 200)
background(255)
stroke(0)
stroke_weight(2)
no_fill

begin_shape
(0..width).step(5) do |x|
  y = map(sin(angle), -1, 1, 0, height)
  vertex(x, y)
  angle += angle_vel
end
end_shape
