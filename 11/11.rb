require 'forwardable'

class MonkeyRepository
	include Enumerable
	extend Forwardable

	attr_accessor :modulo

	def_delegators :@monkeys, :each, :[], :fetch, :length, :size, :empty?, :any?

	def initialize
		@monkeys = []
		@modulo = 1
	end

	def new_monkey!(items, operation, divisor, receiver_true, receiver_false)
		monkey = Monkey.new(items, operation, divisor, receiver_true, receiver_false, self)
		@monkeys << monkey
		@modulo *= monkey.divisor
	end
end

@repository = MonkeyRepository.new

class Monkey
	attr_reader :items_inspected, :items, :divisor
	def initialize(items, operation, divisor, receiver_true, receiver_false, repository)
		@items = items
		@new_items = []
		@operation = operation
		@divisor = divisor
		@receiver_true = receiver_true
		@receiver_false = receiver_false
		@repository = repository
		@items_inspected = 0
	end

	def execute!
		@items.each do |item|
			item = @operation.(item)
			item %= @repository.modulo

			# uncomment for part 1
			# item /= 3

			@repository[item % @divisor == 0 ? @receiver_true : @receiver_false]
				.receive_item!(item)
		end
		@items_inspected += @items.size
		@items = []
	end

	def receive_item!(item)
		@items << item
	end
end

def execute_rounds(rounds)
	rounds.times do |i|
		@repository.each(&:execute!)
	end
end

File.readlines('in.txt').each_slice(7) do |monkey_input|
	items = monkey_input[1].split(":")[1].split(",").map(&:to_i)
	operation_str = monkey_input[2].chomp.split("=").last
	operation = eval("lambda { |old| #{operation_str} }")
	divisor = monkey_input[3].split(" ").last.to_i
	receiver_true = monkey_input[4].split(" ").last.to_i
	receiver_false = monkey_input[5].split(" ").last.to_i
	@repository.new_monkey!(
		items, operation, divisor, receiver_true, receiver_false
	)
end

execute_rounds(10_000)
p @repository.map(&:items_inspected).tap(&:sort!).last(2).inject(&:*)