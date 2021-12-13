# frozen_string_literal: true

file = File.open('input')

Point = Struct.new(:x, :y)
Instruction = Struct.new(:along, :index)

points, instructions = file.read.split("\r\n\r\n").map { |it| it.split("\r\n").map(&:chomp) }

@points = points.map { |point| Point.new(*point.split(',').map(&:to_i)) }
@instructions = instructions.map do |instruction|
  along, index = instruction.split.last.split('=')
  Instruction.new(along, index.to_i)
end

def visualize(points)
  width = points.map(&:x).max + 1
  height = points.map(&:y).max + 1

  paper = Array.new(height) { Array.new(width) { '.' } }

  points.each do |point|
    paper[point.y][point.x] = '#'
  end

  paper.each do |row|
    row.each do |col|
      print col
    end
    puts
  end
end

def fold_up(index)
  @points = @points.map do |point|
    if point.y < index
      point.dup
    else
      Point.new(point.x, -point.y + 2 * index)
    end
  end
end

def fold_left(index)
  @points = @points.map do |point|
    if point.x < index
      point.dup
    else
      Point.new(-point.x + 2 * index, point.y)
    end
  end
end

def fold(instruction)
  if instruction.along == 'x'
    fold_left(instruction.index)
  else
    fold_up(instruction.index)
  end
end

visualize(@points)
@instructions.each do |instruction|
  fold(instruction)
  pp "Fold: #{instruction.along} at #{instruction.index}:"
  # visualize(@points)
  pp "Points: #{@points.map { |point| [point.x, point.y] }.uniq.size}"
  puts
end
visualize(@points)
