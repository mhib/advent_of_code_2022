require 'set'
SHAPES = [
	[[2, 3, 4, 5]],
	[
		[3],
		[2, 3, 4],
		[3]
	],
	[
		[2, 3, 4],
		[4],
		[4]
	],
	[
		[2],
		[2],
		[2],
		[2]
	],
	[
		[2, 3],
		[2, 3]
	]
]

def get_shape(idx)
	SHAPES[idx].map(&:dup)
end

class Game
	attr_reader :filled_blocks
	def initialize(input)
		@current_height = 0
		@filled_blocks = Set.new((0..6).map { |x| [-1, x] })
		@current_shape = 0
		@input = input
		@input_idx = 0
		@states = {}
	end


	def simulate!(blocks)
		blocks.times do
			drop!
		end
		@current_height
	end

	def find_cycle!
		i = 1
		while true
			drop!
			seen_idx = remember_state!(i)
			return [seen_idx, i] if seen_idx
			i += 1
		end
	end

	def drop!
		shape = get_shape(@current_shape)
		height = @current_height + 3

		while true
			move!(height, shape, next_instruction!)

			if any_colision?(shape, height)  
				add_block!(shape, height)
				break
			end
			height -= 1
		end


		@current_shape += 1
		@current_shape %= SHAPES.size
	end

	private

	def remember_state!(i)
		xs = {}
		@current_height.downto(-1) do |height|
			0.upto(6) do |x|
				if !xs[x] && @filled_blocks.include?([height, x])
					xs[x] = height - @current_height
				end
			end
			break if xs.size == 6
		end
		state = [@input_idx, @current_shape, xs.sort.map(&:last)]
		if @states[state]
			return @states[state]
		end
		@states[state] = i
		nil
	end

	def add_block!(shape, height)
		shape.each_with_index do |row, y|
			row.each do |x|
				@filled_blocks << [height + y, x]
			end
		end
		@current_height = [@current_height, shape.size + height].max
	end

	def any_colision?(shape, height)
		shape.each_with_index do |row, y|
			row.each do |x|
				return true if @filled_blocks.include?([height + y - 1, x])
			end
		end
		false
	end

	def next_instruction!
		val = @input[@input_idx]
		@input_idx += 1
		@input_idx %= @input.size
		val
	end

	def move!(height, shape, delta)
		shape.each_with_index do |row, y|
			row.each do |x|
				return shape if (delta == 1) && x == 6
				return shape if (delta == -1) && x == 0
				return shape if @filled_blocks.include?([height + y, x + delta])
			end
		end
		shape.each do |row|
			row.map! { |el| el + delta }
		end
		shape
	end
end

deltas = []
IO.read('in.txt').chomp.each_char do |c|
	deltas << (c == '<' ? -1 : 1)
end

# For part 1
# value = 2022

value = 1000000000000
game = Game.new(deltas)
cycle_start, cycle_end = game.find_cycle!

cycle_size = (cycle_end - cycle_start)

game = Game.new(deltas)
value_at_start = game.simulate!(cycle_start - 1)

game = Game.new(deltas)
cycle_value = game.simulate!(cycle_end - 1) - value_at_start

value -= (cycle_start - 1)
cycle_count = value / cycle_size

missing = (value % cycle_size)
game = Game.new(deltas)
missing_value = game.simulate!(cycle_start + missing - 1) - value_at_start

p (value_at_start + cycle_value * cycle_count + missing_value)