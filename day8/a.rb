require "set"
require "matrix"

grid = Matrix[*File.readlines("day8/input.txt", chomp: true).map { _1.split("") }]
ROW_COUNT, COL_COUNT = grid.row_count, grid.column_count
antinodes = Set.new
antennas = Hash.new { |hash, key| hash[key] = [] }

def reciprocal_nodes(v0, v1)
  vr = v1 - v0

  [v0 - vr, v1 + vr]
end

grid.each_with_index do |cell, row, col|
  next if cell == "."

  antennas[cell].each do |existing_vector|
    v0, v1 = [existing_vector, Vector[row, col]].sort_by { [_1[0], _1[1]] }

    reciprocal_nodes(v0, v1).each do |node|
      antinodes.add(node) if node[0].between?(0, ROW_COUNT - 1) && node[1].between?(0, COL_COUNT - 1)
    end
  end

  antennas[cell] << Vector[row, col]
end

puts antinodes.size
