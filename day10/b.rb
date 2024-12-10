require "matrix"

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

  row.between?(0, opts[:row_count] - 1) && col.between?(0, opts[:col_count] - 1)
end

def new_trail_branch(altitude, position, opts: OPTS)
  return 1 if altitude == 9

  next_altitude = altitude + 1
  summits = 0

  opts[:directions].each do |direction|
    next_vector = position + direction
    valid_altitude = opts[:chart][next_vector[0], next_vector[1]].to_i == next_altitude

    if valid_altitude && valid_position?(next_vector)
      summits += new_trail_branch(next_altitude, next_vector)
    end
  end

  summits
end

chart.each_with_index do |altitude, row, col|
  next unless altitude == "0"

  summits = new_trail_branch(0, Vector[row, col])
  summit_scores << summits if summits.positive?
end

puts summit_scores.sum
