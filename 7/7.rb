class FileNode
	attr_reader :name, :is_dir, :size, :children, :parent

	def initialize(name, is_dir, size, parent)
		@name = name
		@is_dir = is_dir
		@size = size
		@children = {}
		@parent = parent
	end

	def get_child(child_name, child_is_dir, child_size)
		if (child = @children[child_name])
			return child
		end

		child = FileNode.new(child_name, child_is_dir, child_size, self)
		@children[child_name] = child
		if child_size != 0
			propagate_size_increase_to_ancestors(child_size)
		end
	end

	def find_size_greater_than(value, acc = [])
		return acc if size < value
		if size >= value
			acc << self
		end
		children.each_value do |child|
			if child.is_dir
				child.find_size_greater_than(value, acc)
			end
		end
		acc
	end

	protected

	def propagate_size_increase_to_ancestors(increase)
		@size += increase
		@parent&.propagate_size_increase_to_ancestors(increase)
	end
end

class State
	attr_reader :stack, :root

	def initialize()
		@root = FileNode.new("", true, 0, nil)
		@stack = [@root]
	end

	def current
		@stack.last
	end

	def cd_down
		if @stack.size != 1
			@stack.pop
		end
	end

	def cd_root
		@stack = [@root]
	end

	def cd(dir)
		@stack << current.get_child(dir, true, 0)
	end

	def add_file_info(name, is_dir, size)
		current.get_child(name, is_dir, size)
	end
end

@state = State.new

def parse_line(line)
	words = line.split(" ")
	if words[0] == "$"
		return if words[1] == 'ls'

		if words[2] == '/'
			@state.cd_root
		elsif words[2] == '..'
			@state.cd_down
		else
			@state.cd(words[2])
		end
		return
	end

	size, name = words
	if size == 'dir'
		@state.add_file_info(name, true, 0)
	else
		@state.add_file_info(name, false, size.to_i)
	end
end

File.readlines('in.txt').each { parse_line(_1) }

p @state.root.find_size_greater_than(@state.root.size - 40000000).map(&:size).min