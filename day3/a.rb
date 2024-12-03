numbers = File.read("day3/input.txt").scan(/mul\((\d+),(\d+)\)/)

total = numbers.inject(0) do |sum, (x, y)|
  sum + (x.to_i * y.to_i)
end

puts total
