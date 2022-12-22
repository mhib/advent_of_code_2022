grid = []
commands = ""

RIGHT = 0
DOWN = 1
LEFT = 2
UP = 3

File.readlines('in.txt', chomp: true).each do |line|
	next if line.empty?
	if line[0] =~ /\d/
		commands = line
		next
	end

	grid << line.chars
end

moves = commands.split(/[A-Z]/).tap { |x| x.map!(&:to_i) }
rotations = commands.split(/\d+/).tap(&:shift)

def print_grid(grid, y, x, direction)
	grid.each_with_index do |row, idx|
		if idx != y
			puts row.join
			next
		end
		row = row.dup
		if direction == RIGHT
			row[x] = '>'
		elsif direction == DOWN
			row[x] = 'v'
		elsif direction == LEFT
			row[x] = '<'
		else
			row[x] = '^'
		end
		puts row.join
	end
end

def apply_moves(grid, moves, rotations)
	columns = grid.size

	direction = RIGHT

	x = grid[0].index('.')
	y = 0

	idx = 0
	while idx < moves.size
		move = moves[idx]

		if direction == RIGHT
			row = grid[y]
			move.times do
				if x == row.size - 1 || row[x + 1] == ' '
					next_cell_index = row.bsearch_index { |x| x != ' ' }
					break if row[next_cell_index] == '#'
					x = next_cell_index
				elsif row[x + 1] == '#'
					break
				else
					x += 1
				end
			end
		elsif direction == LEFT
			row = grid[y]
			move.times do
				if x == 0 || row[x - 1] == ' '
					next_cell_index = row.size - 1
					break if row[next_cell_index] == '#'
					x = next_cell_index
				elsif row[x - 1] == '#'
					break
				else
					x -= 1
				end
			end
		elsif direction == DOWN
			move.times do
				if y == columns - 1 || grid[y + 1][x].nil? || grid[y + 1][x] == ' '
					next_cell_index = 0.upto(columns - 1).find { |tmp| grid[tmp][x] && grid[tmp][x] != ' ' }
					break if grid[next_cell_index][x] == '#'
					y = next_cell_index
				elsif grid[y + 1][x] == '#'
					break
				else
					y += 1
				end
			end
		else
			move.times do
				if y == 0 || grid[y - 1][x].nil? || grid[y - 1][x] == ' '
					next_cell_index = (columns - 1).downto(0).find { |tmp| grid[tmp][x] && grid[tmp][x] != ' ' }
					break if grid[next_cell_index][x] == '#'
					y = next_cell_index
				elsif grid[y - 1][x] == '#'
					break
				else
					y -= 1
				end
			end
		end
		rotation = rotations[idx]
		break unless rotation
		if rotation == 'L'
			direction -= 1
		else
			direction += 1
		end
		direction %= (UP + 1)

		idx += 1
	end

	1000 * (y + 1) + 4 * (x + 1) + direction
end

p apply_moves(grid, moves, rotations)
