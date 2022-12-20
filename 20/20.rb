require 'set'
class Node
	attr_accessor :prev, :val, :idx, :next
	def initialize(val, idx)
		@val = val
		@idx = idx
	end
end

initial_order = []
nodes = {}
counts = Hash.new(0)
first = nil
last = nil
File.readlines('in.txt', chomp: true).each do |line|
	val = line.to_i

	# Comment-out for part1
	val *= 811589153

	counts[val] += 1

	node = Node.new(val, counts[val])
	nodes[[node.val, counts[val]]] = node
	node.prev = last
	last&.next = node
	if first.nil?
		first = node
	end
	last = node
	initial_order << val
end
first.prev = last
last.next = first

def get_values(nodes)
	val = []
	visited = Set[[0, 1]]
	current = nodes[[0, 1]]
	while true
		val << current.val
		current = current.next
		break unless visited.add?([current.val, current.idx])
	end
	val
end

def move(node, size)
	if node.val.positive?
		# node.prev, node, prev_next, prev_next.next
		(node.val % (size - 1)).times do
			prev_next = node.next
			node.next = prev_next.next
			prev_next.prev = node.prev
			prev_next.prev.next = prev_next
			prev_next.next = node
			node.prev = prev_next
			node.next.prev = node
		end
	else
		# prev_prev.prev, prev_prev, node, node.next
		((-node.val) % (size - 1)).times do
			prev_prev = node.prev
			node.prev = prev_prev.prev

			prev_prev.next = node.next
			prev_prev.next.prev = prev_prev

			prev_prev.prev = node

			node.next = prev_prev
			node.prev.next = node
		end
	end
end

def part1(nodes, initial_order)
	counts = Hash.new(0)
	initial_order.each do |el|
		counts[el] += 1
		node = nodes[[el, counts[el]]]

		move(node, initial_order.size)
	end


	arr = get_values(nodes)

	p [arr.size, initial_order.size]

	sum = [1000, 2000, 3000].map do |idx|
		arr[idx % arr.size]
	end.sum
	
	p sum
end

def part2(nodes, initial_order)
	10.times do
		counts = Hash.new(0)
		initial_order.each do |el|
			counts[el] += 1
			node = nodes[[el, counts[el]]]

			move(node, initial_order.size)
		end
	end


	arr = get_values(nodes)

	p [arr.size, initial_order.size]

	sum = [1000, 2000, 3000].map do |idx|
		arr[idx % arr.size]
	end.sum
	
	p sum
end

# Part 1
# part1(nodes, initial_order)

part2(nodes, initial_order)