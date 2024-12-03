require "matrix"

a0 = []
a1 = []

File.foreach("input.txt") do |line|
  left, right = line.split.map(&:to_i)
  a0 << left
  a1 << right
end

left_matrix = Matrix.column_vector(a0.sort)
right_matrix = Matrix.column_vector(a1.sort)

differences = (left_matrix - right_matrix).map(&:abs)

total_distance = differences.to_a.flatten.sum

puts total_distance
