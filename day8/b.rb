require "set"
require "matrix"

grid = Matrix[*File.readlines("day8/input.txt", chomp: true).map { _1.split("") }]
ROW_COUNT, COL_COUNT = grid.row_count, grid.column_count
antinodes = Set.new
antennas = Hash.new { |hash, key| hash[key] = [] }

def reciprocal_nodes(v0, v1, row_count: ROW_COUNT, col_count: COL_COUNT)
  valid_nodes = [v0, v1]
  vr = v1 - v0
  v0_in_range, v1_in_range = true

  while v0_in_range || v1_in_range
    v0 -= vr
    v1 += vr

    v0_in_range = v0[0].between?(0, row_count - 1) && v0[1].between?(0, col_count - 1)
    v1_in_range = v1[0].between?(0, row_count - 1) && v1[1].between?(0, col_count - 1)

    valid_nodes << v0 if v0_in_range
    valid_nodes << v1 if v1_in_range
  end

  valid_nodes
end

grid.each_with_index do |cell, row, col|
  next if cell == "."

  antennas[cell].each do |existing_vector|
    v0, v1 = [existing_vector, Vector[row, col]].sort_by { [_1[0], _1[1]] }

    antinodes.merge(reciprocal_nodes(v0, v1))
  end

  antennas[cell] << Vector[row, col]
end

puts antinodes.size