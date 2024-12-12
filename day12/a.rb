require "matrix"
require "set"

# INPUT_FILE = "day12/input.txt"
INPUT_FILE = "day12/sample.txt"
PLOT = Matrix[*File.readlines(INPUT_FILE, chomp: true).map(&:chars)]
ROW_COUNT = PLOT.row_count
COL_COUNT = PLOT.column_count
DIRECTIONS = [Vector[-1, 0], Vector[1, 0], Vector[0, -1], Vector[0, 1]]

visited = Set.new
total_price = 0

def valid_position?(row, col)
  row.between?(0, ROW_COUNT - 1) && col.between?(0, COL_COUNT - 1)
end

def valid_region?(row, col, region_type)
  valid_position?(row, col) && PLOT[row, col] == region_type
end

def calculate_contiguous_region(region_type, start_position, visited)
  queue = Set.new([start_position])
  contiguous_regions = Set.new
  perimeter = 0

  until queue.empty?
    position = queue.first

    queue.delete(position)
    contiguous_regions.add(position)
    visited.add(position)

    DIRECTIONS.each do |direction|
      next_vector = position + direction
      next_row, next_col = next_vector.to_a

      if valid_region?(next_row, next_col, region_type) && !visited.include?(next_vector)
        queue.add(next_vector)
      end

      unless valid_region?(next_row, next_col, region_type)
        perimeter += 1
      end
    end
  end

  contiguous_regions.size * perimeter
end

PLOT.each_with_index do |region_type, row, col|
  position = Vector[row, col]
  next if visited.include?(position)

  visited.add(position)

  total_price += calculate_contiguous_region(region_type, position, visited)
end

puts total_price
