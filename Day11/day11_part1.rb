# frozen_string_literal: true

file = File.open('input')

@energy_levels = file.readlines.map(&:chomp).map { |line| line.split('').map(&:to_i) }

@rows = @energy_levels.length
@cols = @energy_levels[0].length

def increase
  (0...@rows).each do |row|
    (0...@cols).each do |col|
      @energy_levels[row][col] += 1
    end
  end
end

def octo_flash(row, col)
  @energy_levels[row][col] = 0

  ((row - 1)..(row + 1)).each do |r|
    ((col - 1)..(col + 1)).each do |c|
      @energy_levels[r][c] += 1 if r >= 0 && r < @rows && c >= 0 && c < @cols && !(r == row && c == col)
    end
  end
end

def flash
  changed = true
  flashed = []

  while changed
    changed = false

    (0...@rows).each do |row|
      (0...@cols).each do |col|
        next unless @energy_levels[row][col] > 9

        octo_flash(row, col)
        flashed << [row, col]
        changed = true
      end
    end
  end

  flashed
end

def reset(flashed)
  flashed.each do |row, col|
    @energy_levels[row][col] = 0
  end
end

def step
  increase
  flashed = flash
  reset(flashed)

  flashed.length
end

pp((1..100).sum { step })
