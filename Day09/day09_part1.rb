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

pp low_points.sum { |row, col| @height_map[row][col] + 1 }
