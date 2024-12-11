def simulate_stonemasonry(number, depth, cache: CACHE)
  return 1 if depth.zero?

  key = [number, depth]

  return cache[key] if cache[key]

  next_depth = depth - 1

  cache[key] = if number.to_i.zero?
    simulate_stonemasonry("1", depth - 1)
  elsif (size = number.length).even?
    x1, x2 = number[0...size / 2].to_i.to_s, number[size / 2..-1].to_i.to_s

    simulate_stonemasonry(x1, depth - 1) + simulate_stonemasonry(x2, depth - 1)
  else
    simulate_stonemasonry((number.to_i * 2024).to_s, next_depth)
  end
end

BLINK = 75
stones = File.read("day11/input.txt").split(" ")
CACHE = {}
stones.each { simulate_stonemasonry(_1, BLINK) }
total = CACHE.sum { |(_number, depth), count| depth == BLINK ? count : 0 }

puts total
