# frozen_string_literal: true

require 'set'

file = File.open('input')

@small_map = file.readlines.map(&:chomp).map { |line| line.split('').map(&:chomp).map(&:to_i) }
@small_height = @small_map[0].size
@small_width = @small_map[0].size

@height = @small_height * 5
@width = @small_width * 5

@danger_map = Array.new(@height) { Array.new(@width) }
(0...@small_height).each do |row|
  (0...@small_width).each do |col|
    5.times do |i|
      5.times do |j|
        new_value = (@small_map[row][col] + i + j - 1) % 9 + 1
        @danger_map[(@small_height * i) + row][(@small_width * j) + col] = new_value
      end
    end
  end
end

@cost_map = Array.new(@height) { Array.new(@width) }
@cost_map[0][0] = 0

def coords_around(location)
  row, col = location

  [[-1, 0], [1, 0], [0, -1], [0, 1]].filter_map do |x, y|
    [row + x, col + y] unless (row + x).negative? || (col + y).negative? || (row + x >= @width) || (col + y >= @height)
  end
end

def find_shortest_path(from, to)
  open_locations = [from]
  visited = Set.new
  found = false

  until found
    current_location = open_locations.min_by { |row, col| @cost_map[row][col] } # should use a heap here
    current_row, current_col = current_location

    visited << current_location
    open_locations -= [current_location]

    coords_around(current_location).each do |neighbour|
      next if visited.include?(neighbour)

      neighbour_row, neighbour_col = neighbour

      new_cost = @cost_map[current_row][current_col] + @danger_map[neighbour_row][neighbour_col]
      existing_cost = @cost_map[neighbour_row][neighbour_col]

      if existing_cost.nil? || new_cost < existing_cost
        open_locations << neighbour
        @cost_map[neighbour_row][neighbour_col] = new_cost
      end

      found = true if neighbour == to
    end
  end
end

find_shortest_path([0, 0], [@width - 1, @height - 1])
pp @cost_map[@width - 1][@height - 1]
