
def from_snafu(str)
	sum = 0
	pow = 1
	str.chars.reverse_each do |chr|
		if chr == '='
			sum += pow * -2
		elsif chr == '-'
			sum += pow * -1
		else
			sum += pow * chr.to_i
		end
		pow *= 5
	end
	sum
end

def mul_to_snafu(mul)
	return "=" if mul == -2
	return "-" if mul == -1
	return mul.to_s
end

def to_snafu(num)
	max_power = (0..32).bsearch { |x| (5 ** x) * 2 >= num }

	power = 5 ** max_power

	res = String.new("")
	while power > 0
		val = (-2..2).min_by { |s| (num - (s * power)).abs }
		res << mul_to_snafu(val)
		num -= val * power
		power /= 5
	end
	res
end

sum = 0

File.readlines('in.txt', chomp: true).each do |line|
	sum += from_snafu(line)
end

p to_snafu(sum)