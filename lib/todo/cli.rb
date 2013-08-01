require 'todo/todo'

module Todo
class CLI
	def run(args)
		case args[0]
		when "add", "a"
			TodoList.load.add args[1..-1]
		when "list", "ls", "l"
			TodoList.load.list args[1..-1].join('_').to_sym
		when "done", "d"
			TodoList.load.done *args[1..-1].map(&:to_i)
		when "bump", "b"
			if args.length == 2
				TodoList.load.bump args[1].to_i
			elsif args.length == 3
				TodoList.load.bump args[1].to_i, args[2].to_i
			end
		when "init"
			TodoList.init 
		when "clear", "cl"
			TodoList.load.clear
		end
	end
end
end
