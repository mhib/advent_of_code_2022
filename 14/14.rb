require 'set'

Point = Struct.new(:y, :x)
@grid = Set[]

@sands = 0

@max_y = 0

def add_points(segments)
	current_segment_idx = 0

	0.upto(segments.size - 2) do |idx|
		current = segments[idx]
		succ = segments[idx + 1]
		if current.y != succ.y
			min, max = [current.y, succ.y].minmax
			min.upto(max) { @grid << Point.new(_1, current.x)}
		else
			min, max = [current.x, succ.x].minmax
			min.upto(max) { @grid << Point.new(current.y, _1)}
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
				point = Point.new(y, x)
				@grid << point
				@sands += 1
				break
			end
			if !@grid.include?(Point.new(y + 1, x))
				y += 1
			elsif !@grid.include?(Point.new(y + 1, x - 1))
				y += 1
				x -= 1
			elsif !@grid.include?(Point.new(y + 1, x + 1))
				y += 1
				x += 1
			else
				point = Point.new(y, x)
				@grid << point
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
p simulate_till_end