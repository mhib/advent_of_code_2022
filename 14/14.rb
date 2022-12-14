require 'set'

Point = Struct.new(:y, :x)
@points = Set.new
@grid = []

@sands = 0

@max_y = 0

def add_points(segments)
	current_segment_idx = 0

	0.upto(segments.size - 2) do |idx|
		current = segments[idx]
		succ = segments[idx + 1]
		if current.y != succ.y
			min, max = [current.y, succ.y].minmax
			min.upto(max) { @points << Point.new(_1, current.x) }
		else
			min, max = [current.x, succ.x].minmax
			min.upto(max) { @points << Point.new(current.y, _1) }
		end
	end
	segments.each { @max_y = [@max_y, _1.y].max }
end

def simulate_till_end
	while true
		y = 0
		x = 500
		while true
			if y >= @max_y + 1
				@grid[y][x] = true
				@sands += 1
				break
			end
			if !@grid[y + 1][x]
				y += 1
			elsif !@grid[y + 1][x - 1]
				y += 1
				x -= 1
			elsif !@grid[y + 1][x + 1]
				y += 1
				x += 1
			else
				@grid[y][x] = true
				@sands += 1
				return @sands if y == 0
				break
			end
		end
	end
end
File.readlines('in.txt').each do |line|
	add_points(line.split(" -> ").map { Point.new(*_1.split(",").map(&:to_i).reverse) })
end

@grid = Array.new(@max_y + 2) { Array.new(500 + @max_y + 2, false) }
@points.each { @grid[_1.y][_1.x] = true }
@points = Set.new

p simulate_till_end