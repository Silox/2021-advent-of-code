file = File.open("input")

fishes = file.readline.split(',').map(&:to_i)

tally = [0] * 9
fishes.tally.each do |k, v|
  tally[k] = v
end

256.times do
  breeders = tally.shift

  tally[6] += breeders
  tally[8] = breeders
end

pp tally.sum
