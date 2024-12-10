require "matrix"
require "set"

chart = Matrix[*File.readlines("day10/input.txt", chomp: true).map { _1.split("") }]
summit_scores = []
OPTS = {
  chart: chart,
  row_count: chart.row_count,
  col_count: chart.column_count,
  directions: [Vector[-1, 0], Vector[1, 0], Vector[0, -1], Vector[0, 1]]
}

def valid_position?(position, opts: OPTS)
  row, col = position[0], position[1]

  row >= 0 && row < opts[:row_count] && col >= 0 && col < opts[:col_count]
end

def new_trail_branch(altitude, position, visited, opts: OPTS)
  return Set[position] if altitude == 9

  visited.add(position)
  summits = Set.new
  next_altitude = altitude + 1

  opts[:directions].each do |vector|
    next_vector = position + vector
    valid_altitude = opts[:chart][next_vector[0], next_vector[1]].to_i == next_altitude

    if valid_altitude && valid_position?(next_vector) && !visited.include?(next_vector)
      summits.merge(new_trail_branch(next_altitude, next_vector, visited))
    end
  end

  visited.delete(position)

  summits
end

chart.each_with_index do |altitude, row, col|
  next unless altitude == "0"

  visited = Set.new
  summits = new_trail_branch(0, Vector[row, col], visited)

  summit_scores << summits.size if summits.size.positive?
end

puts summit_scores.sum
