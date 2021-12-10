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
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25_137,
}.freeze


OPENING_BRACKETS = BRACKETS.keys
CLOSING_BRACKETS = BRACKETS.values

def opening_bracket?(char)
  OPENING_BRACKETS.include?(char)
end

def closing_bracket?(char)
  CLOSING_BRACKETS.include?(char)
end

def error_score(instruction)
  stack = []

  erroneous_closing_char = nil
  cursor = 0

  while erroneous_closing_char.nil? && cursor < instruction.size
    char = instruction[cursor]

    if opening_bracket?(char)
      stack << char
    elsif char == BRACKETS[stack.last]
      stack.pop
    else
      erroneous_closing_char = char
    end

    cursor += 1
  end

  erroneous_closing_char
end

pp @instructions.filter_map { |it| CORRECTION_POINTS[error_score(it)] }.sum
