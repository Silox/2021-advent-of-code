# frozen_string_literal: true

file = File.open('input')

@height_map = file.readlines.map(&:chomp).map { |line| line.split('').map(&:to_i) }

@rows = @height_map.size
@cols = @height_map.first.size

def local_minimum?(row, col)
  height = @height_map[row][col]

  return false if (row - 1) >= 0 && @height_map[row - 1][col] <= height
  return false if (col - 1) >= 0 && @height_map[row][col - 1] <= height
  return false if row + 1 < @rows && @height_map[row + 1][col] <= height
  return false if col + 1 < @cols && @height_map[row][col + 1] <= height

  true
end

low_points = (0...@rows).flat_map do |row|
  (0...@cols).filter_map do |col|
    [row, col] if local_minimum?(row, col)
  end
end

pp low_points.sum { |row, col| @height_map[row][col] + 1 }
