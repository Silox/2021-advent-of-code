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

  def hash
    [@x, @y].hash
  end

  def eql?(other)
    [@x, @y].eql?([other.x, other.y])
  end
end
