# frozen_string_literal: true

file = File.open('input')

@instructions = file.readlines.map(&:chomp).map { |line| line.split('') }

BRACKETS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>',
}.freeze

CORRECTION_POINTS = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4,
}.freeze

OPENING_BRACKETS = BRACKETS.keys
CLOSING_BRACKETS = BRACKETS.values

def opening_bracket?(char)
  OPENING_BRACKETS.include?(char)
end

def closing_bracket?(char)
  CLOSING_BRACKETS.include?(char)
end

def missing_brackets(instruction)
  stack = []

  has_error = false
  cursor = 0

  while !has_error && cursor < instruction.size
    char = instruction[cursor]

    if opening_bracket?(char)
      stack << char
    elsif char == BRACKETS[stack.last]
      stack.pop
    else
      has_error = true
    end

    cursor += 1
  end

  return nil if has_error

  stack.reverse.map { |it| BRACKETS[it] }
end

def correction_score(missing_brackets)
  missing_brackets.inject(0) { |acc, missing_bracket| acc * 5 + CORRECTION_POINTS[missing_bracket] }
end

scores = @instructions.filter_map(&method(:missing_brackets)).map(&method(:correction_score)).sort

pp scores[scores.length / 2]
