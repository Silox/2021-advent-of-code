# frozen_string_literal: true

file = File.open('input')

@height_map = file.readlines.map(&:chomp).map { |line| line.split('').map(&:to_i) }

@rows = @height_map.size
@cols = @height_map.first.size

def points_around(row, col)
  points = []
  points << [row - 1, col] if (row - 1) >= 0
  points << [row, col - 1] if (col - 1) >= 0
  points << [row + 1, col] if row + 1 < @rows
  points << [row, col + 1] if col + 1 < @cols
  points
end

def local_minimum?(row, col)
  height = @height_map[row][col]

  points_around(row, col).all? { |row, col| @height_map[row][col] > height}
end

low_points = (0...@rows).flat_map do |row|
  (0...@cols).filter_map do |col|
    [row, col] if local_minimum?(row, col)
  end
end

def visited?(visited_map, row, col)
  visited_map[row][col]
end

def visit(visited_map, row, col)
  visited_map[row][col] = true
end

def flood(visited_map, row, col)
  return 0 if visited?(visited_map, row, col)

  visit(visited_map, row, col)

  points_around = points_around(row, col).reject do |row, col|
    visited?(visited_map, row, col) || @height_map[row][col] == 9
  end

  1 + points_around.sum do |row, col|
    flood(visited_map, row, col)
  end
end

def basin_size(row, col)
  visited_map = Array.new(@rows) { Array.new(@cols) { false } }
  flood(visited_map, row, col)
end

pp low_points.map { |row, col| basin_size(row, col) }.sort.reverse[0, 3].reduce(:*)
