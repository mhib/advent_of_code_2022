require 'set'

Node = Struct.new(:flow, :neis)

@nodes = {}

LINE_REGEX = /Valve ([A-Z]+).* rate=(\d+);.* valves? (.+)$/
def parse_node(line)
	id, flow, neis = line.scan(LINE_REGEX)[0]
	neis = neis.split(", ")
	@nodes[id] = Node.new(flow.to_i, neis)
end


File.readlines('in.txt').each do |line|
	parse_node(line)
end

# Compress nodes without flow
def get_distances(node)
	q = [[node, 0]]
	res = {}
	visited = Set[node]
	while q.any?
		el, dist = q.shift
		@nodes[el].neis.each do |nei|
			next unless visited.add?(nei)
			nei_node = @nodes[nei]
			res[nei] = dist + 1 if nei_node.flow != 0
			q << [nei, dist + 1] if nei_node.flow == 0
		end
	end
	res.to_a
end
@nodes = Hash[@nodes.map do |k, v|
	next if v.flow == 0 && k != 'AA'
	[k, Node.new(v.flow, get_distances(k))]
end.compact]
@node_keys = @nodes.keys.sort
@nodes = @nodes.sort.map { |e| e[1] }
@nodes.each { |node| node.neis.map! { |nei| [@node_keys.bsearch_index { |x| x >= nei[0] }, nei[1]] } }
@whole_set_flag = @nodes.each_index.reduce(0) { |m, e| @nodes[e].flow > 0 ? m | (1 << e) : m }


# O(nodes * 2^nodes * days * players)
@states = {}
State = Struct.new(:current, :opened, :left, :players)

def visit(state)
	if @whole_set_flag == state.opened
		return 0
	end
	if state.left == 0
		return 0 if state.players == 1
		val = visit(State.new(0, state.opened, 26, 1))
		return val
	end

	if (val = @states[state])
		return val
	end

	node = @nodes[state.current]
	max = 0
	if node.flow > 0 && (state.opened & (1 << state.current)) == 0
		added = node.flow * (state.left - 1)
		max = added + visit(State.new(state.current, (state.opened | (1 << state.current)), state.left - 1, state.players))
	end
	node.neis.each do |nei, dist|
		next if dist > state.left
		val = visit(State.new(nei, state.opened, state.left - dist, state.players))
		if val > max
			max = val
		end
	end
	@states[state] = max
end

p @nodes

# Part 1
# p visit(State.new(0, 0, 30, 1))

# Part 2
p visit(State.new(0, 0, 26, 2))
