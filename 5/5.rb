@state = :buckets

@stack = Array.new(9) { [] }

File.readlines("in.txt").each do |line|
	if @state == :buckets
		unless line.start_with?("[")
			@state = :moves
			next
		end
		chars = line.chars
		(0..8).each do |idx|
			chr = chars[idx * 4 + 1]
			next if chr == " "
			@stack[idx].unshift(chr)
		end
	end
	next unless line.start_with?("move")
	count, from, to = line.split(" ").map(&:to_i).reject(&:zero?)


	
	# first solution
	# count.times { @stack[to - 1] << @stack[from - 1].pop }

	@stack[to - 1].push(*@stack[from - 1].pop(count))
end
p @stack.map(&:last).join