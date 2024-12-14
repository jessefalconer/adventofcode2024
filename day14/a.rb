# INPUT_FILE = "day14/input.txt"
# ROW_COUNT, COL_COUNT = 103, 101
INPUT_FILE = "day14/sample.txt"
ROW_COUNT, COL_COUNT = 7, 11
SECONDS = 100

nw_count = 0
ne_count = 0
sw_count = 0
se_count = 0

ROBOTS = File.readlines(INPUT_FILE, chomp: true).map do |line|
  x0, y0, vx, vy = line.match(/p=(\-?\d+),(\-?\d+) v=(\-?\d+),(\-?\d+)/)[1..4].map(&:to_i)

  x1 = (x0 + (vx * SECONDS)) % COL_COUNT
  y1 = (y0 + (vy * SECONDS)) % ROW_COUNT

  if y1 < ROW_COUNT / 2 && x1 < COL_COUNT / 2
    nw_count += 1
  elsif y1 < ROW_COUNT / 2 && x1 > COL_COUNT / 2
    ne_count += 1
  elsif y1 > ROW_COUNT / 2 && x1 < COL_COUNT / 2
    sw_count += 1
  elsif y1 > ROW_COUNT / 2 && x1 > COL_COUNT / 2
    se_count += 1
  end
end

puts nw_count * ne_count * sw_count * se_count
