require "matrix"
require "set"

INPUT_FILE = "day12/input.txt"
# INPUT_FILE = "day12/sample.txt"
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
    end
  end

  contiguous_regions
end

def normalize_polygon(contiguous_regions)
  max_rows = contiguous_regions.max_by { |v| v[0] }[0]
  max_cols = contiguous_regions.max_by { |v| v[1] }[1]
  min_rows = contiguous_regions.min_by { |v| v[0] }[0]
  min_cols = contiguous_regions.min_by { |v| v[1] }[1]
  sub_plot = Matrix.zero(max_rows - min_rows + 1, max_cols - min_cols + 1)

  contiguous_regions.each do |position|
    row, col = position.to_a
    sub_plot[row - min_rows, col - min_cols] = 1
  end

  sub_plot
end

def is_edge?(row, col, next_region, current_region, row_count, col_count)
  in_bounds = row.between?(0, row_count - 1) && col.between?(0, col_count - 1)

  if in_bounds
    current_region == 1 ? next_region == 0 : next_region == 1
  else
    current_region == 1
  end
end

def score_edges(pattern)
  score = 0
  in_group = false

  pattern.each_with_index do |bool, _i|
    if bool
      unless in_group
        in_group = true
        score += 1
      end
    else
      in_group = false
    end
  end

  score
end

def calculate_edges(sub_plot)
  top_edges_count = 0
  additional_row = Array.new(sub_plot.column_count, 0)
  sub_plot = Matrix.rows(sub_plot.to_a + [additional_row])
  row_count = sub_plot.row_count
  col_count = sub_plot.column_count

  (0...row_count).each do |row|
    top_edges = []

    (0...col_count).each do |col|
      current_region = sub_plot[row, col]

      v0_top = Vector[row - 1, col]
      v0_region_top = sub_plot[*v0_top] || 0

      top_edges << is_edge?(v0_top[0], v0_top[1], v0_region_top, current_region, row_count, col_count)
    end
    top_edges_count += score_edges(top_edges)
  end

  top_edges_count
end

PLOT.each_with_index do |region_type, row, col|
  position = Vector[row, col]
  next if visited.include?(position)

  visited.add(position)

  contiguous_regions = calculate_contiguous_region(region_type, position, visited)

  sub_plot = normalize_polygon(contiguous_regions)
  sub_plot_rotated = Matrix[*sub_plot.transpose.to_a.map(&:reverse)]

  edges = calculate_edges(sub_plot)
  edges_rotated = calculate_edges(sub_plot_rotated)

  total_price += (edges_rotated + edges) * contiguous_regions.size
end

puts total_price
