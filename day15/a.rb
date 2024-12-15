require "matrix"

INPUT_FILE = "day15/input.txt"
# INPUT_FILE = "day15/sample.txt"
map, commands = File.read(INPUT_FILE, chomp: true).split("\n\n")
map = Matrix[*map.split("\n").map { |line| line.split("\n")[0].split("") }]
commands = commands.split("\n").flat_map(&:chars)

Robot = Struct.new(:map, :row, :col, :command) do
  VECTORS = {
    "^" => [-1, 0],
    "v" => [1, 0],
    "<" => [0, -1],
    ">" => [0, 1]
  }

  WALL = "#"
  BOX = "O"
  ROBOT = "@"
  FREE = "."

  def next_position
    [row + VECTORS[command][0], col + VECTORS[command][1]]
  end

  def line_of_sight
    next_row, next_col = next_position
    los = []

    while los.last != WALL
      los << map[next_row, next_col]
      next_row += VECTORS[command][0]
      next_col += VECTORS[command][1]

      break if los.last == FREE
    end

    los
  end

  def move
    return if line_of_sight.first == WALL
    return if line_of_sight.none? { _1 == FREE }

    next_row, next_col = next_position

    if line_of_sight.first == BOX
      next_los_row, next_los_col = next_row, next_col
      map[row, col] = FREE
      map[next_los_row, next_los_col] = ROBOT

      (line_of_sight.size - 1).times do
        map[next_los_row + VECTORS[command][0], next_los_col + VECTORS[command][1]] = BOX
        next_los_row += VECTORS[command][0]
        next_los_col += VECTORS[command][1]
      end
    else
      map[row, col] = FREE
      map[next_row, next_col] = ROBOT
    end

    self.row = next_row
    self.col = next_col
    self.map = map
  end
end


def calculate_gps_sum(map)
  map.each_with_index.sum do |element, row, col|
    next 0 if element != BOX

    (100 * row) + col
  end
end

row_start, col_start = map.each_with_index do |element, row, col|
  break [row, col] if element.match?(ROBOT)
end

robot = Robot.new(map, row_start, col_start)

commands.each do |command|
  robot.command = command
  robot.move
end

puts calculate_gps_sum(robot.map)
