require "matrix"

TARGET = "MAS"
count = 0
crossword = Matrix[*File.readlines("day4/input.txt", chomp: true).map { _1.split("") }]
columns = crossword.column_count # width, dim_n
rows = crossword.row_count # length, dim_m

(0..columns).each do |i|
  (0..rows).each do |j|
    next unless crossword[i, j] == "A"

    range_up = ([i+1, rows].min).downto([0, i - 1].max)
    range_down = ([i-1, 0].max)..[rows, i + 1].min
    domain_right = ([j-1, 0].max)..[columns, j + 1].min
    domain_left = ([j+1, columns].min).downto([0, j - 1].max)

    vectors = {
      up_right: range_up.zip(domain_right),
      down_right: range_down.zip(domain_right),
      down_left: range_down.zip(domain_left),
      up_left: range_up.zip(domain_left)
    }

    count += 1 if vectors.each_value.count do |coords|
      next if coords.flatten.any?(nil)

      word = coords.map { crossword[_1, _2] }.join

      word == TARGET
    end > 1
  end
end

puts count
