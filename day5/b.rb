rules, updates = File.read("day5/input.txt").split("\n\n")
RULES = rules.split("\n")
  .each_with_object(Hash.new { |h, k| h[k] = [] }) do |rule, hash|
    k, v = rule.split("|")
    hash[k] << v
  end
updates = updates.split("\n").map { _1.split(",") }
valid = []

def sort_line(line, changed = false)
  line.each_with_index do |number, index|
    values_to_test = line[0...index]

    if (changed = (values_to_test & RULES[number]).any?)
      line[index], line[values_to_test.index((values_to_test & RULES[number]).first)] =
        line[values_to_test.index((values_to_test & RULES[number]).first)], line[index]
    end

    break sort_line(line) if changed
  end
end

updates.each do |line|
  update_valid = line.each_with_index.any? do |number, index|
    values_to_test = line[0...index]

    (values_to_test & RULES[number]).any?
  end

  if update_valid
    valid << line[sort_line(line).length / 2].to_i
  end
end

puts valid.inject(:+)
