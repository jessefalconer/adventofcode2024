require "matrix"

# INPUT_FILE = "day13/input.txt"
INPUT_FILE = "day13/sample.txt"
A_COST = 3
B_COST = 1
OFFSET = 10000000000000
cost = 0
parameters = File.read(INPUT_FILE, chomp: true).split("\n\n")

parameters.each do |parameter|
  eq1, eq2, coords = parameter.split("\n")

  x0, y0 = eq1.scan(/-?\d+/).map(&:to_i)
  x1, y1 = eq2.scan(/-?\d+/).map(&:to_i)
  x3, y3 = coords.scan(/-?\d+/).map(&:to_i)
  x3 = OFFSET + x3
  y3 = OFFSET + y3

  #    a  *  v  =  b
  # |x0 x1| |x| = |x3|
  # |y0 y1| |y| = |y3|

  a = Matrix[[x0, x1], [y0, y1]]
  b = Matrix[[x3], [y3]]
  v = a.inv * b

  next if v[0, 0].denominator != 1 || v[1, 0].denominator != 1

  x, y = v.to_a.flatten

  cost += ((A_COST * x) + (B_COST * y)).to_i
end

puts cost
