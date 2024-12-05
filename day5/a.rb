rules, updates = File.read("day5/input.txt").split("\n\n")
rules = rules.split("\n")
  .each_with_object(Hash.new { |h, k| h[k] = [] }) do |rule, hash|
    k, v = rule.split("|")
    hash[k] << v
  end
updates = updates.split("\n").map { _1.split(",") }
valid = []

updates.each do |line|
  update_valid = line.each_with_index.all? do |number, index|
    values_to_test = line[0...index]

    (values_to_test & rules[number]).empty?
  end

  valid << line[line.length / 2].to_i if update_valid
end

puts valid.inject(:+)
