require 'set'

NEIS = [[0, -1], [0, 1], [-1, 0], [1, 0]]

def get_priority(chr)
	return chr.ord if chr >= 'a'
	return 'a'.ord if chr == 'S'
	return 'z'.ord if chr == 'E'
end

def find_starts(grid)
	starts = []
	grid.each_with_index do |row, y|
		row.each_with_index do |cell, x|
			starts << [y, x] if yield cell
		end
	end
	starts
end

def bfs(grid, starts)
	q = starts.map { |s| [s, 0] }
	visited = Set.new(starts)

	while q.any?
		(y, x), dist = q.shift

		current = get_priority(grid[y][x])

		NEIS.each do |delta_y, delta_x|
			new_y = y + delta_y
			new_x = x + delta_x
			next if new_y < 0 || new_x < 0
			next if new_y >= grid.size || new_x >= grid[0].size
			return dist + 1 if grid[new_y][new_x] == 'E' && current >= get_priority('z') - 1
			next if get_priority(grid[new_y][new_x]) - current > 1

			key = [new_y, new_x]
			next unless visited.add?(key)

			q << [key, dist + 1]
		end
	end
end

@grid = []
File.readlines('in.txt').each do |line|
	@grid << line.chomp.chars
end

# p bfs(@grid, find_starts(@grid) { |c| c == 'S' }) # first part
p bfs(@grid, find_starts(@grid) { |c| c == 'S' || c == 'a' })