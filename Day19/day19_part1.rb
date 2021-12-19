# frozen_string_literal: true

require 'json'

$minimum_overlap = 12

file = File.open('input_small')

# Credits: https://stackoverflow.com/a/16467849/1068495
def generate_rotations(b)
  roll = ->(c) { [c[0], c[2], -c[1]] }
  turn = ->(c) { [-c[1], c[0], c[2]] }

  Enumerator.new do |enum|
    2.times do
      3.times do
        b = roll.call(b)
        enum.yield b
        3.times do
          b = turn.call(b)
          enum.yield b
        end
      end
      b = roll.call(turn.call(roll.call(b)))
    end
  end
end

def beacon_configurations(beacons)
  beacons.map { |beacon| generate_rotations(beacon).to_a }.transpose
end

def add_vector(coordinate, vector)
  coordinate.zip(vector).map { |x, y| x + y }
end

def subtract_vector(coordinate, vector)
  coordinate.zip(vector).map { |x, y| x - y }
end

class Scanner
  attr_accessor :configurations, :orientation_configuration, :position

  def initialize(beacons)
    @configurations = beacon_configurations(beacons)
  end

  def find_overlap_with(other)
    beacons = configurations[0]

    other.configurations.each_with_index do |other_beacons, orientation_configuration|
      beacons.each do |beacon|
        other_beacons.each do |other_beacon|
          offset = subtract_vector(other_beacon, beacon)
          overlap = beacons & other_beacons.map { |coordinate| subtract_vector(coordinate, offset) }

          next unless overlap.length >= $minimum_overlap

          return [orientation_configuration, offset]
        end
      end
    end

    nil
  end

  def find_overlapping_scanners(other_scanners)
    other_scanners.find_all do |scanner|
      overlap = find_overlap_with(scanner)

      if overlap.nil?
        false
      else
        orientation_configuration, offset = overlap
        scanner.orientation_configuration = orientation_configuration
        scanner.position = offset

        true
      end
    end
  end

  def absolute_beacons
    configurations[orientation_configuration].map { |beacon| subtract_vector(beacon, position) }
  end
end

scanners = file.read.split("\r\n\r\n").map do |scanner_input|
  _, *beacon_coordinates = scanner_input.split("\r\n").map(&:chomp)
  Scanner.new(beacon_coordinates.map { |beacon_coordinate| beacon_coordinate.split(',').map(&:to_i) })
end

scanner_zero, *other_scanners = scanners
scanner_zero.orientation_configuration = 0
scanner_zero.position = [0, 0, 0]

until other_scanners.empty?
  overlapping_scanners = scanner_zero.find_overlapping_scanners(other_scanners)

  other_scanners -= overlapping_scanners
  pp "Remaining: #{other_scanners.length}"

  overlapping_scanners.each do |scanner|
    scanner_zero.configurations[0] = (scanner_zero.configurations[0] + scanner.absolute_beacons).uniq
  end
end

pp scanner_zero.configurations[0].length
