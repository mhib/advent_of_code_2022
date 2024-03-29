require 'set'

# ~4 times faster than version with only no-flow-compression

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
			q << [nei, dist + 1]
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

@states = {}
State = Struct.new(:current, :opened, :left, :players)
def visit(state)
	return 0 if state.opened == @whole_set_flag

	if state.left == 0
		return 0 if state.players == 1
		val = visit(State.new(0, state.opened, 26, 1))
		return val
	end
	if (val = @states[state])
		return val
	end
	max = 0
	@nodes[state.current].neis.each do |nei, dist|
		next if dist + 1 > state.left
		next if state.opened & (1 << nei) != 0
		node = @nodes[nei]
		added = node.flow * (state.left - dist - 1)
		max = [
			max,
			added + visit(State.new(nei, state.opened | (1 << nei), state.left - dist - 1, state.players))
		].max
	end
	@states[state] = max
end


# Part 1
# p visit(State.new(0, 1, 30, 1))

p visit(State.new(0, 1, 26, 2))
