require 'set'

Blizzard = Struct.new(:y, :x, :direction) do
	def move!(length, width)
		self.y += direction[0]
		if y == 0
			self.y = length - 2
		end
		if y == length - 1
			self.y = 1
		end
		self.x += direction[1]
		if x == 0
			self.x = width - 2
		end
		if x == width - 1
			self.x = 1
		end
	end

	def to_point
		[y, x]
	end
end

blizzards = []
width = 0
length = 0
File.readlines('in.txt', chomp: true).each.with_index do |line, y|
	if width == 0
		width = line.size
	end
	line.each_char.with_index do |chr, x|
		next if chr == '#'
		next if chr == '.'
		if chr == '>'
			blizzards << Blizzard.new(y, x, [0, 1])
		elsif chr == '<'
			blizzards << Blizzard.new(y, x, [0, -1])
		elsif chr == '^'
			blizzards << Blizzard.new(y, x, [-1, 0])
		else
			blizzards << Blizzard.new(y, x, [1, 0])
		end
	end
	length += 1
end

def get_moves(y, x)
	[[0, -1], [0, 0], [0, 1], [-1, 0], [1, 0]].map do |delta_y, delta_x|
		[y + delta_y, x + delta_x]
	end
end

def find_path(length, width, blizzards, start, goal, left = 1)
	q = [start]
	steps = 1


	while true
		occupied = Set.new

		new_points = Set.new

		blizzards.each do |blizzard|
			blizzard.move!(length, width)
			occupied << blizzard.to_point
		end

		while q.any?
			point = q.pop

			unless occupied.include?(point)
				new_points << point
			end

			get_moves(*point).each do |new_point|
				if new_point == goal
					if left == 1
						return steps
					else
						return steps + find_path(length, width, blizzards, goal, start, left - 1)
					end
				end
				next if new_point[0] <= 0
				next if new_point[0] >= length - 1
				next if new_point[1] <= 0
				next if new_point[1] >= width - 1
				next if occupied.include?(new_point)
				new_points << new_point
			end
		end
		q = new_points.to_a

		steps += 1
	end
end


# Part1
# p find_path(length, width, blizzards, [0, 1], [length - 1, width - 2])

p find_path(length, width, blizzards, [0, 1], [length - 1, width - 2], 3)