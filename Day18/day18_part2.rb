# frozen_string_literal: true

require 'json'

file = File.open('input')

input = file.readlines.map { |line| JSON.parse(line) }

def calculate_depths(fish, depth = 0)
  if fish.is_a?(Array)
    fish.map { |f| calculate_depths(f, depth + 1) }
  else
    depth
  end
end

@fishes = input.map(&:flatten)
@depths = input.map { |fishes| calculate_depths(fishes).flatten }

def sum(lhs, rhs)
  lhs_fishes, lhs_depths = lhs
  rhs_fishes, rhs_depths = rhs

  [lhs_fishes + rhs_fishes, (lhs_depths + rhs_depths).map { |i| i + 1 }]
end

def explode(fish)
  fishes, depths = fish

  explosion_index = depths.find_index { |depth| depth > 4 }
  return false if explosion_index.nil?

  fishes[explosion_index - 1] += fishes[explosion_index] if explosion_index != 0
  fishes[explosion_index + 2] += fishes[explosion_index + 1] if explosion_index != fishes.length - 2

  fishes.delete_at(explosion_index)
  fishes[explosion_index] = 0
  depths.delete_at(explosion_index)
  depths[explosion_index] = 4

  true
end

def split(fish)
  fishes, depths = fish

  split_index = fishes.find_index { |fish| fish >= 10 }
  return false if split_index.nil?

  halved_big_fish = (fishes[split_index] / 2.0)

  fishes[split_index] = halved_big_fish.floor
  fishes.insert(split_index + 1, halved_big_fish.ceil)

  depths[split_index] += 1
  depths.insert(split_index + 1, depths[split_index])

  true
end

def reduce(fishes)
  changed = true

  while changed
    while explode(fishes)
    end

    changed = split(fishes)
  end

  fishes
end

def unflatten(fishes, depths, depth = 0, index = 0)
  if depths[index] > depth
    left, index = unflatten(fishes, depths, depth + 1, index)
    right, index = unflatten(fishes, depths, depth + 1, index)
    [[left, right], index]
  else
    [fishes[index], index + 1]
  end
end

def magnitude(fish)
  return fish if fish.is_a?(Numeric)

  first, second = fish
  3 * magnitude(first) + 2 * magnitude(second)
end

max_magnitude = @fishes.zip(@depths).permutation(2).map do |c|
  first_fish, second_fish = c
  summed_fish = reduce(sum(first_fish, second_fish))
  unflattened_summed_fish = unflatten(*summed_fish).first
  magnitude(unflattened_summed_fish)
end.max

pp max_magnitude
