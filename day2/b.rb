count = 0

def valid_row?(row)
  slope = row.sort == row || row.sort.reverse == row
  tolerance = row.each_cons(2).all? { (_1 - _2).abs <= 3 && !(_1 - _2).zero? }

  slope && tolerance
end

File.foreach("day2/input.txt") do |line|
  row = line.split.map(&:to_i)

  count += 1 if row.each_with_index.any? do |_, index|
    row_combination = row[0...index] + row[index + 1..-1]

    valid_row?(row_combination)
  end
end

puts count
