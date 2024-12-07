require "matrix"
require "set"

CaretMover = Struct.new(:map, :row, :col, :direction, :simulation) do
  attr_accessor :start_row, :start_col, :start_direction, :start_coordinates,
    :obstructions_encountered, :loops_found, :infinite_loop, :out_of_bounds

  def initialize(*)
    super
    @start_row = row
    @start_col = col
    @start_direction = direction
    @start_coordinates = [row, col]
    @obstructions_encountered = Set.new
    @infinite_loop = false
    @loops_found = 0
    @out_of_bounds = false
  end

  VECTORS = {
    "^" => [-1, 0],
    "v" => [1, 0],
    "<" => [0, -1],
    ">" => [0, 1]
  }

  ROTATION = {
    "^" => ">",
    ">" => "v",
    "v" => "<",
    "<" => "^"
  }

  OBSTRUCTION = "#"
  MARKER = "X"
  NEW_POSITION = "."

  def next_position
    [row + VECTORS[direction][0], col + VECTORS[direction][1]]
  end

  def next_position_out_of_bounds?
    next_row, next_col = next_position

    next_row.negative? || next_row >= map.row_count ||
      next_col.negative? || next_col >= map.column_count
  end

  def attempt_simulation?(next_element)
    !simulation && next_element == NEW_POSITION && next_position != start_coordinates
  end

  def move
    loop do
      return (self.out_of_bounds = true) if next_position_out_of_bounds?

      next_row, next_col = next_position
      next_element = map[next_row, next_col]

      if attempt_simulation?(next_element)
        simulated_map = map.dup
        simulated_map[next_row, next_col] = OBSTRUCTION
        simulated_guard = CaretMover.new(simulated_map, start_row, start_col, start_direction, true)

        until simulated_guard.infinite_loop || simulated_guard.out_of_bounds
          simulated_guard.move
        end

        self.loops_found += 1 if simulated_guard.infinite_loop
      end

      if next_element == OBSTRUCTION
        if simulation
          self.infinite_loop = self.obstructions_encountered.include?([row, col, direction])
          self.obstructions_encountered.add [row, col, direction]
        end
        self.direction = ROTATION[direction]
      else
        self.row = next_row
        self.col = next_col
        self.map[row, col] = MARKER

        break
      end
    end
  end
end

map = Matrix[*File.readlines("day6/input.txt", chomp: true).map { _1.split("") }]

row_start, col_start, caret_start = map.each_with_index do |element, row, col|
  break row, col, element if VECTORS.keys.include?(element)
end

guard = CaretMover.new(map, row_start, col_start, caret_start, false)

until guard.out_of_bounds
  guard.move
end

puts guard.loops_found
