class Task
	attr_accessor :cost, :delta
	def initialize(cost, delta)
		@cost = cost
		@delta = delta
	end
end
class Cpu
	attr_reader :cycle_values
	def initialize
		@queue = []
		@x = 1
		@cycle_values = []
	end

	def new_instruction!(cost, delta)
		@queue << Task.new(cost, delta)
	end

	def interpret_queue!
		while @queue.any?
			@queue.first.cost -= 1
			if @queue.first.cost > 0
				@cycle_values << @x
				next
			end
			@cycle_values << @x
			@x += @queue.shift.delta
		end
	end
end

@cpu = Cpu.new
File.readlines('in.txt').each do |line|
	command, delta = line.split(" ")
	if command == 'noop'
		@cpu.new_instruction!(1, 0)
	else
		@cpu.new_instruction!(2, delta.to_i)
	end
end
@cpu.interpret_queue!

rows = 0.step(200, 40).map do |row_start|
	res = String.new("")
	1.upto(40) do |col|
		cycle = row_start + col
		cycle_value = @cpu.cycle_values[cycle - 1]

		sprite = cycle_value..(cycle_value + 2)
		if sprite.cover?(col)
			res << "█" # For visibility sake
		else
			res << " "
		end
	end
	res
end

puts rows.join("\n")