def sgn(n)
  n <=> 0
end

class Segment
  attr_accessor :start_point, :end_point

  def initialize(start_point, end_point)
    @start_point = start_point
    @end_point = end_point
  end

  def diagonal?
    (@start_point.x != @end_point.x) && (@start_point.y != @end_point.y)
  end

  def vector(start_number, end_number)
    sgn(end_number - start_number)
  end

  def x_vector
    vector(@start_point.x, @end_point.x)
  end

  def y_vector
    vector(@start_point.y, @end_point.y)
  end

  def discrete_points
    vector = Point.new(x_vector, y_vector)

    cursor_point = @start_point.dup
    points = [@start_point]

    while cursor_point != @end_point
      cursor_point.translate(vector)
      points << cursor_point.dup
    end

    points
  end
end

