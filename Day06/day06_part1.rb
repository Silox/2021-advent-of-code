file = File.open("input")

fishes = file.readline.split(',').map(&:to_i)

tally = [0] * 9
fishes.tally.each do |k, v|
  tally[k] = v
end

80.times do
  breeders = tally.shift

  tally[6] += breeders
  tally << breeders
end

pp tally.sum