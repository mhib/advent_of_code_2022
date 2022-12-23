require 'set'

elves = Set.new
File.readlines('in.txt', chomp: true).each.with_index do |line, y|
	line.each_char.with_index do |chr, x|
		if chr == '#'
			elves << [y, x]
		end
	end
end

ALL_NEIS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

def get_all_neis(y, x)
	ALL_NEIS.map { |delta_y, delta_x| [y + delta_y, x + delta_x] }
end

Direction = Struct.new(:delta, :neis) do
	def get_neis(y, x)
		neis.map do |dy, dx|
			[y + dy, x + dx]
		end
	end

	def apply(y, x)
		[y + delta[0], x + delta[1]]
	end
end

DIRECTIONS = [
	Direction.new([-1, 0], [[-1, -1], [-1, 0], [-1, 1]]),
	Direction.new([1, 0], [[1, -1], [1, 0], [1, 1]]),
	Direction.new([0, -1], [[-1, -1], [0, -1], [1, -1]]),
	Direction.new([0, 1], [[-1, 1], [0, 1], [1, 1]]),
]

def part1(elves, times)
	directions = DIRECTIONS.dup
	times.times do
		new_elves = Hash.new { |h, k| h[k] = [] }


		elves.each do |y, x|
			if get_all_neis(y, x).all? { |ny, nx| !elves.include?([ny, nx]) }
				new_elves[[y, x]] << [y, x]
				next
			end

			proposed = false
			directions.each do |dir|
				if dir.get_neis(y, x).all? { |ny, nx| !elves.include?([ny, nx]) }
					proposed = true
					new_elves[dir.apply(y, x)] << [y, x]
					break
				end
			end
			
			unless proposed
				new_elves[[y, x]] << [y, x]
			end
		end
		elves = Set.new

		new_elves.each do |k, v|
			if v.size == 1
				elves << k
			else
				elves.merge(v)
			end
		end

		dir = directions.shift
		directions << dir
	end

	min_y, max_y = elves.map(&:first).minmax
	min_x, max_x = elves.map(&:last).minmax

	(max_y - min_y + 1) * (max_x - min_x + 1) - elves.size
end

def part2(elves)
	directions = DIRECTIONS.dup
	1.upto(1.0 / 0) do |step|
		new_elves = Hash.new { |h, k| h[k] = [] }


		elves.each do |y, x|
			if get_all_neis(y, x).all? { |ny, nx| !elves.include?([ny, nx]) }
				new_elves[[y, x]] << [y, x]
				next
			end

			proposed = false
			directions.each do |dir|
				if dir.get_neis(y, x).all? { |ny, nx| !elves.include?([ny, nx]) }
					proposed = true
					new_elves[dir.apply(y, x)] << [y, x]
					break
				end
			end
			
			unless proposed
				new_elves[[y, x]] << [y, x]
			end
		end
		elves.clear

		any_moves = false

		new_elves.each do |k, v|
			if v.size == 1
				elves << k
				if k != v[0]
					any_moves = true
				end
			else
				elves.merge(v)
			end
		end

		return step unless any_moves

		dir = directions.shift
		directions << dir
	end
end

# p part1(elves, 10)

p part2(elves)
