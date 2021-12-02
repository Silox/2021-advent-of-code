file = File.open("input")

Instruction = Struct.new(:command, :amount)

instructions = file.readlines.map(&:chomp).map do |line|
  command, amount = line.split
  Instruction.new(command, amount.to_i)
end

horizontal = 0
aim = 0
depth = 0

instructions.each do |instruction|
  case instruction.command
  when 'forward'
    horizontal += instruction.amount
    depth += instruction.amount * aim
  when 'down'
    aim += instruction.amount
  when 'up'
    aim -= instruction.amount
  else
    raise NotImplementedError
  end
end

puts horizontal * depth
