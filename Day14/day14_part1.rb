# frozen_string_literal: true

file = File.open('input')

template, insertion_rules = file.read.split("\r\n\r\n").map { |it| it.split("\r\n").map(&:chomp) }

@template = template.first.chars
@insertion_rules_map = insertion_rules.map { |it| it.split(' -> ') }.to_h

@tally = @template.each_cons(2).map(&:join).tally

10.times do
  new_tally = Hash.new(0)

  @tally.each do |pair, amount|
    chars = pair.chars
    inserted_char = @insertion_rules_map[pair]

    new_tally[chars.first + inserted_char] += amount
    new_tally[inserted_char + chars.last] += amount
  end

  @tally = new_tally
end

char_count = Hash.new(0)
@tally.each do |pair, value|
  first = pair.chars.first
  char_count[first] += value
end

char_count[@template.last] += 1

counts = char_count.values.sort
pp counts.last - counts.first
