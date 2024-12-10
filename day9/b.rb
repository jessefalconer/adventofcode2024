disk_line = File.read("day9/input.txt").chars.flat_map.with_index do |char, index|
  if index.even?
    Array.new(char.to_i, (index / 2).to_s)
  else
    Array.new(char.to_i, ".")
  end
end

free_indexes = {}
char_indexes = {}
last_free_index = nil

disk_line.each_with_index do |char, index|
  if char == "."
    last_free_index ||= index
    free_indexes[last_free_index] = free_indexes.fetch(last_free_index, 0) + 1
  else
    char_indexes[char] = char_indexes.fetch(char, 0) + 1
    last_free_index = nil
  end
end

char_indexes.reverse_each do |char_key, size|
  free_indexes.keys.sort.each do |free_key|
    free_size = free_indexes[free_key]

    next if free_size < size

    size.times do |index|
      disk_line[free_key + index] = char_key
      disk_line[disk_line.rindex(char_key)] = "."
    end

    remaining_space = free_size - size
    free_indexes[free_key + size] = remaining_space if remaining_space.positive?

    free_indexes.delete(free_key)

    break
  end
end

checksum = disk_line.each_with_index.sum do |char, index|
  char == "." ? 0 : char.to_i * index
end

puts checksum
