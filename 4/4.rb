def parse_range(str)
	Range.new(*str.split("-").map(&:to_i))
end

@count = 0
File.readlines('in.txt').each do |line|
	larger, smaller = line.split(",").map { parse_range(_1) }


	val = false
	if larger.min <= smaller.max && smaller.min <= larger.max
		val = true
		@count += 1
	end
end
p @count