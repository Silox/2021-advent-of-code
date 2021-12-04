file = File.open('input')

@numbers = file.readline.split(',').map(&:to_i)

file.readline

@boards = file.read.split("\r\n\r\n").map { |board| board.split("\r\n").map { |line| line.split.map(&:to_i) } }
file.close

def check_line(numbers, line)
  (line - numbers).empty?
end

def check_rows(numbers, board)
  board.any? { |row| check_line(numbers, row) }
end

def check_board(numbers, board)
  matching_row = check_rows(numbers, board)
  matching_column = check_rows(numbers, board.transpose)

  matching_row || matching_column
end

def solve
  index = 0
  last_winning_bingo_board = nil

  while !@boards.empty? && index < @numbers.length
    @boards.reject! do |board|
      check_board(@numbers[0, index + 1], board)
    end

    last_winning_bingo_board = @boards.first if @boards.size == 1

    index += 1
  end

  pp last_winning_bingo_board
  pp @numbers[index - 1]

  pp (last_winning_bingo_board.flatten - @numbers[0, index]).sum * @numbers[index - 1]
end

solve
