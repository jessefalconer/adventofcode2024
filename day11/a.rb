def simulate_stonemasonry(number)
  if number.to_i.zero?
    "1"
  elsif (size = number.length).even?
    [number[0...size/2].to_i.to_s, number[size/2..-1].to_i.to_s]
  else
    (number.to_i * 2024).to_s
  end
end

REHYDRATE_HUMAN_PHOTORECEPTORS = 25
mineral_deposits = File.read("day11/input.txt").split(" ")

REHYDRATE_HUMAN_PHOTORECEPTORS.times do
  mineral_deposits = mineral_deposits.flat_map { simulate_stonemasonry(_1) }
end

puts mineral_deposits.size
