# frozen_string_literal: true

file = File.open('input')

@combinations = file.readlines.map(&:chomp).map do |line|
  line.split(' | ').map { |it| it.split.map { |chars| chars.chars.sort }}
end.to_h

def solve(combination)
  input, output = combination

  char_to_digit = {}

  one_chars = input.find { |chars| chars.length == 2 }
  input -= [one_chars]
  char_to_digit[one_chars] = 1

  four_chars = input.find { |chars| chars.length == 4 }
  input -= [four_chars]
  char_to_digit[four_chars] = 4

  seven_chars = input.find { |chars| chars.length == 3 }
  input -= [seven_chars]
  char_to_digit[seven_chars] = 7

  eight_chars = input.find { |chars| chars.length == 7 }
  input -= [eight_chars]
  char_to_digit[eight_chars] = 8

  top_char = (seven_chars - one_chars).first

  nine_chars = input.find { |chars| chars.length == 6 && ((four_chars + [top_char]) - chars).empty? }
  input -= [nine_chars]
  char_to_digit[nine_chars] = 9

  bottom_char = (nine_chars - four_chars - [top_char]).first

  bottom_left_char = (eight_chars - nine_chars).first

  zero_chars = input.find { |chars| chars.length == 6 && (one_chars - chars).empty? }
  input -= [zero_chars]
  char_to_digit[zero_chars] = 0

  six_chars = input.find { |chars| chars.length == 6 }
  input -= [six_chars]
  char_to_digit[six_chars] = 6

  middle_char = (eight_chars - zero_chars).first

  two_chars = input.find { |chars| chars.include?(bottom_left_char) }
  input -= [two_chars]
  char_to_digit[two_chars] = 2

  top_right_char = (eight_chars - six_chars).first

  three_chars = input.find { |chars| (one_chars - chars).empty? }
  input -= [three_chars]
  char_to_digit[three_chars] = 3

  five_chars = input.first
  char_to_digit[five_chars] = 5

  top_left_char = (eight_chars - two_chars - one_chars).first
  bottom_right_char = (one_chars - [top_right_char]).first

  output.map { |it| char_to_digit[it] }.join.to_i
end

pp @combinations.map { |it| solve(it) }.sum


