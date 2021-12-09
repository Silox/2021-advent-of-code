# frozen_string_literal: true

file = File.open('input')

@combinations = file.readlines.map(&:chomp).map do |line|
  line.split(' | ').map(&:split)
end.to_h

def unique_segments?(output)
  [2, 4, 3, 7].include?(output.size)
end

pp @combinations.values.flatten.count { |output| unique_segments?(output) }
