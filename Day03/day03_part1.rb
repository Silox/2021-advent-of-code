file = File.open("input")

bits = file.readlines.map(&:chomp).map(&:chars).map { |line| line.map(&:to_i) }

result = bits.transpose.map do |line|
  if line.count(1) >= line.count(0)
    1
  else
    0
  end
end

gamma_rate = result.join.to_i(2)
epsilon_rate = 2**bits[0].size - 1 - gamma_rate

pp gamma_rate * epsilon_rate
