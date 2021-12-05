require_relative 'point'
require_relative 'segment'

file = File.open("input")

segments = file.readlines.map(&:chomp).map do |line|
  point1, point2 = line.split(' -> ')

  Segment.new(Point.from_coordinate(point1), Point.from_coordinate(point2))
end

pp segments.reject(&:diagonal?).flat_map(&:discrete_points).tally.filter { |_, v| v > 1 }.count