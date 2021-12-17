# frozen_string_literal: true

file = File.open('input')

string = file.readline
regex = /(?<x_min>-?\d+)\.\.(?<x_max>-?\d+), y=(?<y_min>-?\d+)\.\.(?<y_max>-?\d+)/
@x_min, @x_max, @y_min, @y_max = string.scan(regex).first.map(&:to_i)

def in?(x, y)
  (@x_min..@x_max).include?(x) && (@y_min..@y_max).include?(y)
end

def past?(x, y)
  x > @x_max || y < @y_min
end

def never_going_to_hit(x, y)
  x.zero? && y < @y_min
end

def shoot(x_velocity, y_velocity)
  stop = false
  x = 0
  y = 0
  max_y = 0

  until stop
    x += x_velocity
    y += y_velocity

    max_y = [max_y, y].max

    x_velocity = [x_velocity - 1, 0].max
    y_velocity -= 1

    stop = in?(x, y) || past?(x, y) || never_going_to_hit(x, y)
  end

  max_y if in?(x, y)
end


x_velocities = 0..@x_max
y_velocities = @y_min..1000

velocities = x_velocities.map do |x|
  y_velocities.filter_map do |y|
    shoot(x, y)
  end
end.flatten

pp velocities.sort.last
