file = File.open("input")

Instruction = Struct.new(:command, :amount)

instructions = file.readlines.map(&:chomp).map do |line|
  command, amount = line.split
  Instruction.new(command, amount.to_i)
end

horizontal = 0
depth = 0

instructions.each do |instruction|
  case instruction.command
  when 'forward'
    horizontal += instruction.amount
  when 'down'
    depth += instruction.amount
  when 'up'
    depth -= instruction.amount
  end
end

puts horizontal * depth
