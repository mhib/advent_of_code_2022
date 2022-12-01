INPUT = IO.read('in.txt')

values = INPUT.split("\n")

@sums = []
@sum = 0

values.each do |x|
	int = x.to_i
	if int == 0
		@sums << @sum
		@sum = 0
	else
		@sum += int
	end
end
@sums.sort!
p @sums.last(3).sum