# frozen_string_literal: true

# file = File.open('input_small')
# file = File.open('input_operator_packet_1')
# file = File.open('input_operator_packet_2')
# file = File.open('input_operator_packet_3')
# file = File.open('input_operator_packet_4')
# file = File.open('input_operator_packet_5')
# file = File.open('input_operator_packet_6')
# file = File.open('input_operator_packet_7')
file = File.open('input')

@version = 0

@binary = [file.readline].pack('H*').unpack1('B*')
pp "Input: #{@binary}"

def parse_packet_version(stream)
  version = stream.slice!(0, 3).to_i(2)
  @version += version
  version
end

def parse_packet_type_id(stream)
  stream.slice!(0, 3).to_i(2)
end

def parse_literals(stream)
  literal = ''
  last = stream[0] == '0'

  until last
    stream.slice!(0, 1)
    literal += stream.slice!(0, 4)

    last = stream[0] == '0'
  end

  stream.slice!(0, 1)
  literal += stream.slice!(0, 4)

  pp literal.to_i(2)
end

def parse_length_type_id(stream)
  stream.slice!(0, 1).to_i
end

def parse_total_subpacket_bit_length(stream)
  stream.slice!(0, 15).to_i(2)
end

def parse_number_of_subpackets(stream)
  stream.slice!(0, 11).to_i(2)
end

def parse_operator_packet(stream)
  length_type_id = parse_length_type_id(stream)
  pp "Length type id: #{length_type_id}"

  case length_type_id
  when 0
    total_subpacket_bit_length = parse_total_subpacket_bit_length(stream)
    pp "Subpacket length: #{total_subpacket_bit_length}"
    new_stream = stream.slice!(0, total_subpacket_bit_length)

    parse_packet(new_stream) while new_stream.length.positive?
  when 1
    number_of_subpackets = parse_number_of_subpackets(stream)
    pp "Number of subpackets: #{number_of_subpackets}"
    (0..number_of_subpackets).map do
      parse_packet(stream)
    end
  end
end

def parse_packet(stream)
  pp "Version: #{parse_packet_version(stream)}"

  packet_type_id = parse_packet_type_id(stream)
  pp "Packet type id: #{packet_type_id}"

  case packet_type_id
  when 4
    parse_literals(stream)
  else
    parse_operator_packet(stream)
  end
end

parse_packet(@binary)

pp @version