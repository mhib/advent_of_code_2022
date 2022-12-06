INPUT = IO.read("in.txt")
@occ = {}
LENGTH = 14 # 4 for part 1
INPUT.each_char.with_index do |chr, idx|
	@occ[chr] ||= 0
	@occ[chr] += 1
	if idx - LENGTH >= 0
		val = (@occ[INPUT[idx - LENGTH]] -= 1)
		@occ.delete(INPUT[idx - LENGTH]) if val.zero?
	end

	if @occ.size == LENGTH
		p idx + 1
		return
	end
end