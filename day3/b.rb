instructions = File.read("day3/input.txt").scan(/do\(\)|don't\(\)|mul\(\d+,\d+\)/)
enabled = true

total = instructions.inject(0) do |sum, str|
  if str == "do()"
    enabled = true

    next sum
  elsif str == "don't()"
    enabled = false

    next sum
  end

  if enabled
    sum + str.match(/mul\((\d+),(\d+)\)/).captures.map(&:to_i).inject(:*)
  else
    sum
  end
end

puts total
