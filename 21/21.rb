class Node
	attr_accessor :name, :children, :value, :left, :right, :operator, :left_value, :right_value
	def initialize(name, value, left = nil, operator = nil, right = nil)
		@name = name
		@value = value
		@left = left
		@operator = operator
		@right = right
		@children = []
	end
end

RESOLVED_PATTERN = /(\w+): (-?\d+)/
EQUATION_PATTERN = /(\w+): (\w+) ([\+\-\*\/]) (\w+)/

nodes = {}
queue = []
non_resolved = []
File.readlines('in.txt', chomp: true).each do |line|
	resolved = line.scan(RESOLVED_PATTERN)
	if resolved.any?
		name = resolved[0][0]
		value = resolved[0][1].to_i

		# Comment out for part 1
		if name == "humn"
			value = "x"
		end

		node = Node.new(name, value)
		nodes[name] = node
		queue << node
	else
		name, left, operator, right = line.scan(EQUATION_PATTERN)[0]
		node = Node.new(name, nil, left, operator, right)
		nodes[node.name] = node
		non_resolved << node
	end
end

non_resolved.each do |node|
	nodes[node.left].children << node
	nodes[node.right].children << node
end

def resolve_part_1(nodes, resolved)
	q = resolved

	while q.any?
		el = q.shift

		el.children.each do |child|
			if child.left == el.name
				child.left_value = el.value
			else
				child.right_value = el.value
			end

			if child.right_value && child.left_value
				child.value =  child.left_value.send(child.operator, child.right_value)
				q << child
			end
		end
	end
	nodes["root"].value
end

def resolve_part_2(nodes, resolved)
	q = resolved

	while q.any?
		el = q.shift

		el.children.each do |child|
			if child.left == el.name
				child.left_value = el.value
			else
				child.right_value = el.value
			end

			if child.right_value && child.left_value
				operator = child.operator
				if child.name == 'root'
					operator = '='
				end
				child.value = "(#{child.left_value} #{operator} #{child.right_value})"
				q << child
			end
		end
	end

	# Equation solving outsorced
	`qalc -t '#{nodes["root"].value}'`.split("=").last.to_i
end


# Uncomment for part 1
# p resolve_part_1(nodes, queue)

p resolve_part_2(nodes, queue)