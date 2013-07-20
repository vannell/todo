require 'yaml'

module Todo
	CONTEXT_REGEX=/@\S+/i
	class TodoItem
		attr_reader :contexts, :content
		attr_accessor :done

		def initialize(raw)
			@contexts = raw.scan(CONTEXT_REGEX) || []
			#probably not the right way to exclude contexts from content
			@contexts.each do |c|
				raw.gsub! c, ''
			end
			@content = raw.strip
			@done = false
		end

		def not_done
			! @done
		end
	end

	class TodoList
		def initialize
			@list = []
		end

		def self.file_path
			while ! File.exists?('.todos') && (Dir.pwd != Dir.home) 
				Dir.chdir(File.expand_path('..'))
			end

			'.todos'
		end

		def self.init
			if ! File.exists? '.todos'
				File.open('.todos', 'w') do |f|
					f.write TodoList.new.to_yaml
				end
			end
		end

		def self.load
			if File.exists? file_path
				YAML::load(File.open(file_path))
			else
				TodoList.new
			end
		end

		def save
			File.open(TodoList.file_path, 'w') do |f|
				f.write self.to_yaml
			end
		end

		def add(*args)
			@list << (TodoItem.new args.join(' '))	
			self.save
		end

		def list(option)
			case option
			when :done, :only_done
				filter = :done
			when CONTEXT_REGEX
				target = option.to_s.scan(CONTEXT_REGEX)
				filter = Proc.new {|t| (target - t.contexts).empty? }
			else
				filter = :not_done
			end
			
			@list.select(&filter).each do |todo|
				puts "[#{@list.index(todo) + 1}] #{todo.content} #{todo.contexts.join(' ')}" 
			end
		end

		def done(id)
			yet_not_done = @list.select(&:not_done)

			if id >= 1 && yet_not_done.length >= id
				yet_not_done[id - 1].done = true
			end
			self.save
		end

		def bump(id, up_count=1)
			yet_not_done = @list.select(&:not_done)

			if (up_count > 0 && id > 1) && (
				id > up_count && yet_not_done.length >= id)
				bumped = @list.delete yet_not_done[id - 1]
				@list.insert(id - up_count - 1, bumped)
			end
			self.save
		end
	end
end
