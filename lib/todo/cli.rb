require 'todo/todo'

module Todo
class CLI
	def run(args)
		case args[0]
		when "add"
			TodoList.load.add args[1..-1]
		when "list"
			TodoList.load.list args[1..-1].join('_').to_sym
		when "done"
			TodoList.load.done args[1].to_i
		when "bump"
			TodoList.load.bump args[1].to_i
		when "init"
			TodoList.init 
		end
	end
end
end
