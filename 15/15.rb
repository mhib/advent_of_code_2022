require 'set'

REGEX = /x=(-?\d+), y=(-?\d+)/
def distance(l, r)
	(l[0] - r[0]).abs + (l[1] - r[1]).abs
end

# To lazy to come up with solution that is not based on part 1
@ranges = Array.new(4000000 + 1) { [] }

def add_potential_point(point)
	if (0..400000).cover?(point[0]) && (0..400000).cover?(point[1])
		@ranges[point[0]] << point[1]
	end
end

def parse_sensor(line)
	point, beacon = line.scan(REGEX).map { |c| c.reverse.map(&:to_i) }
	distance = distance(point, beacon)

	([point[0] - distance, 0].max).upto([point[0] + distance, 4000000].min) do |y|
		range = @ranges[y]
		distance_left = distance - (point[0] - y).abs

		range << ([(point[1] - distance_left), 0].max..[(point[1] + distance_left), 4000000].min)
	end
	add_potential_point(point)
	add_potential_point(beacon)
end

def merge_ranges(ranges)
	ranges = ranges.sort_by(&:min)

	current = ranges[0]
	merged = []

	idx = 1
	while idx < ranges.size
		if ranges[idx].min > current.max
			merged << current
			current = ranges[idx]
			idx += 1
			next
		end
		current = (current.min)..[current.max, ranges[idx].max].max
		idx += 1
	end
	merged << current
	merged
end

File.readlines('in.txt').each do |line|
	parse_sensor(line)
end
@ranges.each_with_index do |range, y|
	range = merge_ranges(range)
	if range.size != 1
		p y + ((range.first.max + 1) * 4000000)
		break
	end
end
