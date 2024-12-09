checksums = File.readlines("day9/input.txt", chomp: true).map do |line|
  disk_line = []
  total_chars = 0

  line.chars.each_with_index do |char, index|
    if index.even?
      disk_line.concat(Array.new(char.to_i, index / 2))
      total_chars += char.to_i
    else
      disk_line.concat(["."] * char.to_i)
    end
  end

  free_indexes = disk_line.each_with_index
    .filter_map { _2 <= total_chars && _1 == "." ? _2 : nil }

  free_indexes.each do |free_index|
    removed_index = disk_line.rindex { _1 != "." }

    if removed_index
      disk_line[free_index] = disk_line[removed_index]
      disk_line[removed_index] = "."
    end
  end

  disk_line.each_with_index.sum { _1.to_i * _2.to_i }
end

puts checksums.sum
