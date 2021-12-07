file = File.open("input")

@crab_positions = file.readline.split(',').map(&:to_i)

def fuel_for(position)
  @crab_positions.map do |crab_position|
    difference = (crab_position - position).abs
    (difference * (difference + 1)) / 2
  end.sum
end

pp (@crab_positions.min..@crab_positions.max).map { |position| fuel_for(position) }.min
