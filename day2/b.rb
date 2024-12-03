count = 0

def row_combinations(row)
  row.each_with_index.map do |_, index|
    row[0...index] + row[index + 1..-1]
  end.unshift(row)
end

File.foreach("day2/input.txt") do |line|
  row = line.split.map(&:to_i)

  count += 1 if row_combinations(row).any? do |row|
    slope = row.sort == row || row.sort.reverse == row
    tolerance = row.each_cons(2).all? { (_1 - _2).abs <= 3 && !(_1 - _2).zero? }

    slope && tolerance
  end
end

puts count
