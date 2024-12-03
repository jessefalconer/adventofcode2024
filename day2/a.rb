count = 0

File.foreach("day2/input.txt") do |line|
  row = line.split.map(&:to_i)

  next if row.uniq != row
  next unless row.sort == row || row.sort.reverse == row

  count += 1 if row.each_cons(2).all? { (_1 - _2).abs <= 3 }
end

puts count
