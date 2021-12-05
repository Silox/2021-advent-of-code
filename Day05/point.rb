class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def self.from_coordinate(coordinate)
    x, y = coordinate.split(',').map(&:to_i)
    new(x, y)
  end

  def translate(vector)
    @x += vector.x
    @y += vector.y
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def to_a
    [@x, @y]
  end
end
