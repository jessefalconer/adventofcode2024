require "matrix"

TARGET = "XMAS"
count = 0
crossword = Matrix[*File.readlines("day4/input.txt", chomp: true).map { _1.split("") }]
columns = crossword.column_count # width, dim_n
rows = crossword.row_count # length, dim_m

(0..columns).each do |i|
  (0..rows).each do |j|
    next unless crossword[i, j] == "X"

    range_up = i.downto([0, i - 3].max)
    range_down = i..[rows, i + 3].min
    domain_right = j..[columns, j + 3].min
    domain_left = j.downto([0, j - 3].max)

    vectors = {
      up: range_up.map { [_1, j] },
      up_right: range_up.zip(domain_right),
      right: domain_right.map { [i, _1] },
      down_right: range_down.zip(domain_right),
      down: range_down.map { [_1, j] },
      down_left: range_down.zip(domain_left),
      left: domain_left.map { [i, _1] },
      up_left: range_up.zip(domain_left)
    }

    vectors.each_value do |coords|
      next if coords.flatten.any?(nil)

      word = coords.map { crossword[_1, _2] }.join
      count += 1 if word == TARGET
    end
  end
end

puts count
