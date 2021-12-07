file = File.open("input")

@crab_positions = file.readline.split(',').map(&:to_i)

def fuel_for(position)
  @crab_positions.map { |crab_position| (crab_position - position).abs }.sum
end

pp (@crab_positions.min..@crab_positions.max).map { |position| fuel_for(position) }.min
