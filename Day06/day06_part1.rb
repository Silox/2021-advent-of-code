file = File.open("input")

fishes = file.readline.split(',').map(&:to_i)

@cache = {}

def breed(counter, days_left)
  return 1 if days_left.zero?
  return 1 if counter >= days_left

  remaining_days = days_left - 1

  cached_value = @cache[days_left][counter] unless @cache[days_left].nil?
  return cached_value unless cached_value.nil?

  result = if counter.zero?
             breed(6, remaining_days) + breed(8, remaining_days)
           else
             breed(counter - 1, remaining_days)
           end

  @cache[days_left] = {} if @cache[days_left].nil?
  @cache[days_left][counter] = result
  result
end

pp fishes.tally.map { |fish, tally| tally * breed(fish, 80) }.sum
