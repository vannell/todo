require 'yaml'
require 'colorize'
require 'set'

module Todo
	CONTEXT_REGEX=/@\S+/i
	PLUS_REGEX=/\++/
	MINUS_REGEX=/-+/

	class TodoItem
		include Comparable

		attr_reader :contexts, :content
		attr_accessor :done, :priority

		def initialize(raw)
			@contexts = raw.scan(CONTEXT_REGEX) || []
			#probably not the right way to exclude contexts from content
			@contexts.each do |c|
				raw.gsub! c, ''
			end

			pri = 5
			plus = raw.scan(PLUS_REGEX) || []
			plus.each do |p|
				pri += p.length
				raw.gsub! p, ''
			end

			minus = raw.scan(MINUS_REGEX) || []
			minus.each do |m|
				pri -= m.length
				raw.gsub! m, ''
			end
			@priority = if pri < 0
							0
						elsif pri > 10
							10
						else
							pri
						end

			@content = raw.strip
			@done = false
		end

		def not_done
			! @done
		end

		def <=>(other)
			if done != other.done
				if done
					1
				else
					-1	
				end
			elsif priority != other.priority
				other.priority <=> priority
			else
				content <=> other.content
			end
		end

		def priority=(value)
			if value < 0
				@priority = 0
			elsif value > 10
				@priority = 10
			else
				@priority = value
			end
		end

		def to_s
			case @priority
			when 0, 1
				color = :light_green
			when 2, 3
				color = :green
			when 4, 5, 6
				color = :blue
			when 7, 8
				color = :red
			when 9, 10
				color = :light_red
			end

			"#{@content} #{@contexts.join(' ')}".colorize color
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
				@list.sort!
				f.write self.to_yaml
			end
		end

		def add(*args)
			@list << (TodoItem.new args.join(' '))	
			self.save
		end

		def list_context
			contexts = Set.new
			@list.each do |t|
				contexts.merge t.contexts
			end

			contexts.each {|c| puts c}
			puts "======= No contexts defined =======" if contexts.empty?
		end

		def list(option)
			case option
			when :done, :only_done
				filter = :done
			when CONTEXT_REGEX
				target = option.to_s.scan(CONTEXT_REGEX)
				filter = Proc.new {|t| (target - t.contexts).empty? }
			when /contexts?/
				return list_context #maybe better to dispacth
			else
				filter = :not_done
			end
			
			@list.select(&filter).each do |todo|
				puts "[#{@list.index(todo) + 1}] #{todo}" 
			end
		end

		def done(*ids)
			count = 0
			ids.sort!.select { |i| i >= i && @list.length >= i }.each do |id|
				t = @list[id - 1]
				t.done = true
				count = count + 1
			end
			self.save unless count == 0
		end

		def bump(id, up_count=1)
			if id >= 1 && id <= @list.length
				@list[id - 1].priority += up_count
				self.save
			end
		end

		#clear all done todos
		def clear
			@list.delete_if &:done
			self.save
		end
	end
end
