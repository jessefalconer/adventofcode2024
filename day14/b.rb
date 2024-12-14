require "matrix"

INPUT_FILE = "day14/input.txt"
ROW_COUNT, COL_COUNT = 103, 101
BOARD = Matrix.build(ROW_COUNT, COL_COUNT) { "." }
SECONDS = ROW_COUNT * COL_COUNT
ROBOTS = File.readlines(INPUT_FILE, chomp: true).map do |line|
  x0, y0, vx, vy = line.match(/p=(\-?\d+),(\-?\d+) v=(\-?\d+),(\-?\d+)/)[1..4].map(&:to_i)

  { position: Vector[y0, x0], velocity: Vector[vy, vx] }
end

SECONDS.times do |index|
  ROBOTS.each do |robot|
    y0, x0 = robot[:position].to_a
    vy, vx = robot[:velocity].to_a
    x1 = (x0 + (vx * SECONDS)) % COL_COUNT
    y1 = (y0 + (vy * SECONDS)) % ROW_COUNT

    BOARD[y0, x0] = "."
    BOARD[y1, x1] = "#"
  end

  puts "\n"
  puts "_" * COL_COUNT
  puts "\n"
  puts "Seconds: #{index}"
  puts "\n"
  puts BOARD.to_a.map { |row| row.join }.join("\n")
end
