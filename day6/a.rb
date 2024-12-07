require "matrix"

CaretMover = Struct.new(:map, :row, :col, :direction) do
  attr_accessor :move_count, :out_of_bounds

  def initialize(*)
    super
    @move_count = 0
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

  def move
    loop do
      if map[row, col] == NEW_POSITION
        self.map[row, col] = MARKER
        self.move_count += 1
      end

      next_row, next_col = next_position

      if next_position_out_of_bounds?
        self.move_count += 1

        break self.out_of_bounds = true
      end

      next_element = map[next_row, next_col]

      if next_element == OBSTRUCTION
        self.direction = ROTATION[direction]
      else
        self.row = next_row
        self.col = next_col

        break
      end
    end
  end
end

map = Matrix[*File.readlines("day6/input.txt", chomp: true).map { _1.split("") }]

row_start, col_start, caret_start = map.each_with_index do |element, row, col|
  break row, col, element if VECTORS.keys.include?(element)
end

guard = CaretMover.new(map, row_start, col_start, caret_start)

until guard.out_of_bounds
  out_of_bounds = guard.move
end

puts guard.move_count
