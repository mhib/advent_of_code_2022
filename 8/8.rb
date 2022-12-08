require 'set'

Point = Struct.new(:y, :x)

# Definitely generizable via implementing traversing and ordered stack independently but had no time for it
def visit_from_west(grid, y)
	vals = {}
	stack = []

	grid[y].each_with_index do |el, x|
		while stack.any? && grid[y][stack.last] < el
			right = stack.pop
			left = stack.last ? stack.last : 0
			vals[Point.new(y, right)] = right - left
		end
		stack << x
	end
	while stack.any?
		right = stack.pop
		left = stack.last ? stack.last : 0
		vals[Point.new(y, right)] = right - left
	end
	vals
end

def visit_from_east(grid, y)
	vals = {}
	stack = []

	(grid[y].size - 1).downto(0) do |x|
		el = grid[y][x]
		while stack.any? && grid[y][stack.last] < el
			left = stack.pop
			right = stack.last ? stack.last : grid[y].size - 1
			vals[Point.new(y, left)] = right - left
		end
		stack << x
	end
	while stack.any?
		left = stack.pop
		right = stack.last ? stack.last : grid[y].size - 1
		vals[Point.new(y, left)] = right - left
	end
	vals
end

def visit_from_north(grid, x)
	vals = {}
	stack = []

	0.upto(grid.size - 1) do |y|
		el = grid[y][x]
		while stack.any? && grid[stack.last][x] < el
			bottom = stack.pop
			top = stack.last ? stack.last : 0
			vals[Point.new(bottom, x)] = bottom - top
		end
		stack << y
	end
	while stack.any?
		bottom = stack.pop
		top = stack.last ? stack.last : 0
		vals[Point.new(bottom, x)] = bottom - top
	end
	vals
end

def visit_from_south(grid, x)
	vals = {}
	stack = []

	(grid.size - 1).downto(0) do |y|
		el = grid[y][x]
		while stack.any? && grid[stack.last][x] < el
			top = stack.pop
			bottom = stack.last ? stack.last : grid.size - 1
			vals[Point.new(top, x)] = bottom - top
		end
		stack << y
	end
	while stack.any?
		top = stack.pop
		bottom = stack.last ? stack.last : grid.size - 1
		vals[Point.new(top, x)] = bottom - top
	end
	vals
end

@sum = Hash.new(1)

@grid = []

File.readlines('in.txt').each do |line|
	@grid << line.chomp.each_char.map(&:to_i)
end

0.upto(@grid.size - 1) do |y|
	visit_from_west(@grid, y).each { |k, v| @sum[k] *= v }
	visit_from_east(@grid, y).each { |k, v| @sum[k] *= v }
end

0.upto(@grid[0].size - 1) do |x|
	visit_from_north(@grid, x).each { |k, v| @sum[k] *= v }
	visit_from_south(@grid, x).each { |k, v| @sum[k] *= v }
end

p @sum.max_by(&:last).last

# p @all_seen.size