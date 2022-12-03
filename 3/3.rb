def priority(chr)
	if chr <= 'Z'
		return chr.ord - 'A'.ord + 27
	end
    chr.ord - 'a'.ord + 1
end

@sum = 0
File.readlines('in.txt').each.each_slice(3) do |lines|
	@sum += priority(lines.map(&:chars).inject(:&)[0])
end
puts @sum