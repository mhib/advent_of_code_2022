require 'json'

def compare(left, right)
	if !left.is_a?(Array) && !right.is_a?(Array)
    return [left == right, left < right]
  end
  if !left.is_a?(Array)
    left = [left]
  end
  if !right.is_a?(Array)
    right = [right]
  end

  0.upto([left.size, right.size].min - 1) do |idx|
    same, ok = compare(left[idx], right[idx])
    next if same
    return [false, ok]
  end
  return [left.size == right.size, left.size < right.size]
end

@first = nil
@counter = 0
@idx = 1
@first_divider = [[2]]
@second_divider = [[6]]
@signals = [@first_divider, @second_divider]
File.readlines("in.txt").each do |line|
  line.chomp!
  next if line.empty?
  @signals << JSON.parse(line)
  # if @first.nil?
  #   @first = eval(line)
  # else
  #   _, ok = compare(@first, eval(line))
  #   @counter += @idx if ok
  #   @first = nil
  #   @idx += 1
  # end
end

@signals.sort! do |left, right|
  same, less = compare(left, right)
  next 0 if same
  next -1 if less
  1
end

p (@signals.index(@first_divider) + 1) * (@signals.index(@second_divider) + 1)