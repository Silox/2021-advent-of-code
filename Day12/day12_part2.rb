# frozen_string_literal: true

file = File.open('input')

class CaveSystem
  attr_accessor :caves

  def initialize
    @caves = []
  end

  def add_cave(cave_name)
    find_or_create_cave(cave_name)
  end

  def find_or_create_cave(cave_name)
    find_cave(cave_name) || create_cave(cave_name)
  end

  def create_cave(cave_name)
    cave = Cave.new(cave_name)
    @caves << cave
    cave
  end

  def find_cave(cave_name)
    @caves.find { |cave| cave.name == cave_name }
  end

  def add_connection(cave1, cave2)
    cave1.add_connection(cave2)
    cave2.add_connection(cave1)
  end

  def paths
    start_cave = @caves.find(&:start?)

    travel(start_cave)
  end

  def travel(cave, visited_small_caves = [])
    return 1 if cave.end?

    visited_small_caves += [cave] unless cave.big_cave?

    possible_connections = cave.connections.reject(&:start?)

    small_cave_visited_twice = visited_small_caves.length != visited_small_caves.uniq.length
    possible_connections -= visited_small_caves if small_cave_visited_twice

    return 0 if possible_connections.empty?

    possible_connections.reject(&:start?).sum do |destination|
      travel(destination, visited_small_caves)
    end
  end
end

class Cave
  attr_accessor :name, :connections

  def initialize(name)
    @name = name
    @connections = []
  end

  def add_connection(cave)
    @connections << cave
  end

  def start?
    @name == 'start'
  end

  def end?
    @name == 'end'
  end

  def big_cave?
    @name == name.upcase
  end
end

@cave_connections = file.readlines.map(&:chomp).map { |connection| connection.split('-') }

@cave_system = CaveSystem.new

@cave_connections.each do |cave_connection|
  first, second = cave_connection

  cave1 = @cave_system.add_cave(first)
  cave2 = @cave_system.add_cave(second)

  @cave_system.add_connection(cave1, cave2)
end

pp @cave_system.paths
