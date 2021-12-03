file = File.open("input")

bits = file.readlines.map(&:chomp).map(&:chars).map { |line| line.map(&:to_i) }

oxygen_generator_candidates = bits.dup
co2_scrubber_candidates = bits.dup

@line_length = bits[0].size

def most_occurring_bit(bits, index)
  all_bits = bits.transpose[index]

  if all_bits.count(1) >= all_bits.count(0)
    1
  else
    0
  end
end

def least_occurring_bit(bits, index)
  all_bits = bits.transpose[index]

  if all_bits.count(1) >= all_bits.count(0)
    0
  else
    1
  end
end

def find_candidate(candidates, by)
  (0...@line_length).each do |index|
    break if candidates.size == 1

    by_bit = by.call(candidates, index)
    candidates.select! { |candidate| by_bit == candidate[index] }
  end

  candidates.flatten.join.to_i(2)
end

oxygen_generator_rating = find_candidate(oxygen_generator_candidates, method(:most_occurring_bit))
co2_scrubber_rating = find_candidate(co2_scrubber_candidates, method(:least_occurring_bit))

pp oxygen_generator_rating * co2_scrubber_rating
