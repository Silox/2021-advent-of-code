# frozen_string_literal: true

# file = File.open('input_small')
# file = File.open('input_part2_1')
# file = File.open('input_part2_2')
# file = File.open('input_part2_3')
# file = File.open('input_part2_4')
# file = File.open('input_part2_5')
# file = File.open('input_part2_6')
# file = File.open('input_part2_7')
# file = File.open('input_part2_8')
file = File.open('input')

@binary = [file.readline].pack('H*').unpack1('B*')
pp @binary

def take(stream, amount)
  stream.slice!(0, amount)
end

def parse_packet_version(stream)
  take(stream, 3).to_i(2)
end

def parse_packet_type_id(stream)
  take(stream, 3).to_i(2)
end

def parse_literals(stream)
  literal = ''
  last = stream[0] == '0'

  until last
    take(stream, 1)
    literal += take(stream, 4)

    last = stream[0] == '0'
  end

  take(stream, 1)
  literal += take(stream, 4)

  literal.to_i(2)
end

def parse_length_type_id(stream)
  take(stream, 1).to_i
end

def parse_total_subpacket_bit_length(stream)
  take(stream, 15).to_i(2)
end

def parse_number_of_subpackets(stream)
  take(stream, 11).to_i(2)
end

def parse_operator_packet(stream)
  length_type_id = parse_length_type_id(stream)

  case length_type_id
  when 0
    total_subpacket_bit_length = parse_total_subpacket_bit_length(stream)
    new_stream = take(stream, total_subpacket_bit_length)

    results = []
    results << parse_packet(new_stream) while new_stream.length.positive?
    results
  when 1
    number_of_subpackets = parse_number_of_subpackets(stream)

    (1..number_of_subpackets).map do
      parse_packet(stream)
    end
  end
end

def parse_packet(stream)
  pp "Version: #{parse_packet_version(stream)}"

  packet_type_id = parse_packet_type_id(stream)
  pp "Packet type id: #{packet_type_id}"

  case packet_type_id
  when 0
    parse_operator_packet(stream).sum
  when 1
    parse_operator_packet(stream).inject { |acc, i| acc * i }
  when 2
    parse_operator_packet(stream).min
  when 3
    parse_operator_packet(stream).max
  when 4
    parse_literals(stream)
  when 5
    first, second = parse_operator_packet(stream).to_a
    first > second ? 1 : 0
  when 6
    first, second = parse_operator_packet(stream).to_a
    first < second ? 1 : 0
  when 7
    first, second = parse_operator_packet(stream).to_a
    first == second ? 1 : 0
  end
end

pp parse_packet(@binary)
