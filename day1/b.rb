a0 = []
a1 = []

File.foreach("input.txt") do |line|
  left, right = line.split.map(&:to_i)
  a0 << left
  a1 << right
end

puts a0.map { _1 * a1.count(_1) }.sum
