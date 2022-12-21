require 'parallel'

METALS = %w[ore clay obsidian geode]
State = Struct.new(:left, :robots, :metals)

@blueprints = []

def parse_blueprint(line)
	robot_costs = line.split(".")

	blueprint = robot_costs.map do |robot|
		METALS[0...-1].map do |metal|
			res = robot.scan(/(\d+) #{metal}/)[0]
			res ? res[0].to_i : 0
		end
	end
	@blueprints << blueprint
end

File.readlines('in.txt', chomp: true).each do |line|
	parse_blueprint(line)
end


NON_RESULTABLE_METAL_MAX_IDX = 2
ROBOT_MAX_IDX = 3

# Heuristics:
# 1. It does not make sense to create more robots than maximum of required resources for the given robot kind, as we cannot spend that resource faster than that
# 2. It does not make a new robot, when we already would be able to spend max of that resource each turn till the end
# 3. When left == 2 it does not make sense to build any robot, but geode, as it we wont have time to spend the created resource(i.e. building not-geode is as good as doing nothing)
# 4. It does not make sense to do nothing when we can create all possible robots
def get_blue_print_value(blueprint, steps)
	cache = {}

	maxes = 0.upto(NON_RESULTABLE_METAL_MAX_IDX).map do |idx|
		blueprint.map { |b| b[idx] }.max
	end

	visit = lambda do |state|
		return state.robots.last if state.left == 1
		if (val = cache[state])
			return val
		end

		can_build_count = 0
		if state.metals[0] >= blueprint[0][0]
			can_build_count += 1
		end
		if state.metals[0] >= blueprint[1][0]
			can_build_count += 1
		end
		if state.metals[0] >= blueprint[2][0] && state.metals[1] >= blueprint[2][1]
			can_build_count += 1
		end
		if state.metals[0] >= blueprint[3][0] && state.metals[1] >= blueprint[3][1] && state.metals[2] >= blueprint[3][2]
			can_build_count += 1
		end

		max = 0

		if state.left > 2 && state.robots[0] < maxes[0] && state.robots[0] * state.left + state.metals[0] < maxes[0] * (state.left - 1) && state.metals[0] >= blueprint[0][0]
			metals = state.metals.dup
			metals[0] -= blueprint[0][0]

			0.upto(NON_RESULTABLE_METAL_MAX_IDX) do |metal_idx|
				metals[metal_idx] += state.robots[metal_idx]
			end

			robots = state.robots.dup
			robots[0] += 1
			max = [visit.(State.new(state.left - 1, robots, metals)), max].max
		end

		if state.left > 2 && state.robots[1] < maxes[1] && state.robots[1] * state.left + state.metals[1] < maxes[1] * (state.left - 1) && state.metals[0] >= blueprint[1][0]
			metals = state.metals.dup
			metals[0] -= blueprint[1][0]

			0.upto(NON_RESULTABLE_METAL_MAX_IDX) do |metal_idx|
				metals[metal_idx] += state.robots[metal_idx]
			end

			robots = state.robots.dup
			robots[1] += 1
			max = [visit.(State.new(state.left - 1, robots, metals)), max].max
		end

		if state.left > 2 && state.robots[2] < maxes[2] && state.robots[2] * state.left + state.metals[2] < maxes[2] * (state.left - 1) && state.metals[0] >= blueprint[2][0] && state.metals[1] >= blueprint[2][1]
			metals = state.metals.dup
			metals[0] -= blueprint[2][0]
			metals[1] -= blueprint[2][1]

			0.upto(NON_RESULTABLE_METAL_MAX_IDX) do |metal_idx|
				metals[metal_idx] += state.robots[metal_idx]
			end
			robots = state.robots.dup
			robots[2] += 1
			max = [visit.(State.new(state.left - 1, robots, metals)), max].max
		end

		if state.metals[0] >= blueprint[3][0] && state.metals[1] >= blueprint[3][1] && state.metals[2] >= blueprint[3][2]
			metals = state.metals.dup
			metals[0] -= blueprint[3][0]
			metals[1] -= blueprint[3][1]
			metals[2] -= blueprint[3][2]

			0.upto(NON_RESULTABLE_METAL_MAX_IDX) do |metal_idx|
				metals[metal_idx] += state.robots[metal_idx]
			end

			robots = state.robots.dup
			robots[3] += 1
			max = [visit.(State.new(state.left - 1, robots, metals)), max].max
		end


		if can_build_count < 4 # It does not make sense to just idle if we can build any robot
			metals = state.metals.dup
			0.upto(NON_RESULTABLE_METAL_MAX_IDX) do |metal_idx|
				metals[metal_idx] += state.robots[metal_idx]
			end

			max = [visit.(State.new(state.left - 1, state.robots, metals)), max].max
		end


		cache[state] = max + state.robots.last
	end

	p visit.(State.new(steps, [1, 0, 0, 0], [0, 0, 0]))
end

# Part 1
# p Parallel.map(@blueprints.each_with_index, in_processes: 8) { |b, idx| (idx + 1) * get_blue_print_value(b, 24) }.sum

p Parallel.map(@blueprints.first(3), in_processes: 3) { |b| get_blue_print_value(b, 32) }.inject(:*)
