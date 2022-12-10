require 'set'

class Snake
	def initialize(tail)
		@head = [0, 0]
		@tail = tail
	end

	def left!
		@head[1] -= 1
		@tail.update!(@head)
	end

	def right!
		@head[1] += 1
		@tail.update!(@head)
	end

	def up!
		@head[0] += 1
		@tail.update!(@head)
	end

	def down!
		@head[0] -= 1
		@tail.update!(@head)
	end

	def update!(parent)
		move = parent.zip(@head).map { _1 - _2 }
		return if move[0].abs <= 1 && move[1].abs <= 1
		if move[0].abs > 1 && move[1].abs > 1
			@head[0] += move[0] / 2
			@head[1] += move[1] / 2
		elsif move[0].abs > 1
			@head[0] += move[0] / 2
			@head[1] = parent[1]
		else
			@head[1] += move[1] / 2
			@head[0] = parent[0]
		end
		@tail.update!(@head)
	end

end

class LastNode < Snake
	class FakeNode
		def update!(*); end
	end

	attr_reader :visited

	def initialize
		super(FakeNode.new)
		@visited = Set[[0, 0]]
	end

	def update!(parent)
		super
		@visited << @head.dup
	end
end

@last = LastNode.new
@snake = Snake.new(@last)
8.times { @snake = Snake.new(@snake) } # Comment out for the first part


File.readlines('in.txt').each do |line|
	command, count = line.split(" ")
	count = count.to_i
	if command == 'L'
		count.times { @snake.left! }
	elsif command == 'R'
		count.times { @snake.right! }
	elsif command == 'U'
		count.times { @snake.up! }
	else
		count.times { @snake.down! }
	end
end

p @last.visited.size