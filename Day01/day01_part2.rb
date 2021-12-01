file = File.open("input")

input = file.readlines.map(&:chomp).map(&:to_i)

puts input.each_cons(3).map(&:sum).each_cons(2).count { |first, second| second > first }
