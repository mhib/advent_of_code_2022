require 'set'

@cubes = Set.new
File.readlines('in.txt', chomp: true).each do |line|
	@cubes << line.split(",").map(&:to_i)
end

DELTAS = [[0, 0, -1], [0, 0, 1], [0, -1, 0], [0, 1, 0], [-1, 0, 0], [1, 0, 0]]

def neis(point)
	DELTAS.map do |delta_y, delta_x, delta_z|
		[point[0] + delta_x, point[1] + delta_y, point[2] + delta_z]
	end
end


@max_x = -1.0 / 0
@min_x = 1.0 / 0

@max_y = -1.0 / 0
@min_y = 1.0 / 0

@max_z = -1.0 / 0
@min_z = 1.0 / 0

@cubes.each do |x, y, z|
	@max_x = [@max_x, x].max
	@min_x = [@min_x, x].min

	@max_y = [@max_y, y].max
	@min_y = [@min_y, y].min

	@max_z = [@max_z, z].max
	@min_z = [@min_z, z].min
end

@max_x += 1
@max_y += 1
@max_z += 1

@min_x -= 1
@min_y -= 1
@min_z -= 1

def surface_area
	sum = 0
	@cubes.each do |point|
		neis(point).each do |other_cube|
			if !@cubes.include?(other_cube)
				sum += 1
			end
		end
	end
	sum
end

def external_surface
	q = [[@max_x, @max_y, @max_z]]
	visited = Set[q[0]]
	sum = 0
	while q.any?
		point = q.pop
		neis(point).each do |other_cube|
			next if other_cube[0] < @min_x || other_cube[0] > @max_x
			next if other_cube[1] < @min_y || other_cube[1] > @max_y
			next if other_cube[2] < @min_z || other_cube[2] > @max_z
			next if visited.include?(other_cube)
			if @cubes.include?(other_cube)
				sum += 1
			else
				q << other_cube
				visited << other_cube
			end
		end
	end
	sum
end

# part one
# p surface_area

p external_surface