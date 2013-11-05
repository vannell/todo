# Todo

Yet another simple gem for managing todos lists from CLI and is done in a minimal way (exercise purpose). 

## Installation

Manually

	$ rake install

## Usage

Adding a new Todo

	$ todo add Try to understand this tool

Tag a new todo

	$ todo add Buy some beers @shopping @urgent @vital

Listing all todos yet or not done
    
	$ todo list [done]

Listing by tags

	$ todo list @urgent @shopping
	#...will display our "Buy some beers"

Listing by priorities using + and -

	$ todo list +++ #will show items with priority >= 8
	$ todo list --- #will show items with priority >= 2
	$ todo list -- ++ -- +-+ - #exotic way to say priority >= 4

Listing all defines contexts
	
	$ todo list context[s]

Mark todo as done by its number

	$ todo done 1

Put priorities

* A priority range is defined : lowest -->[0, 10] <-- highest.
* Default priority is 5.
* When adding a new Todo you can put strings of '+' or '-' in your description to increase/decrease default priority.


	$ todo add Try to put priority in my work +++ #will set a priority of 8

Bump todo
	
	$ todo bump todo_id [priority_increment=1] 
	$ todo bump 3    # 3rd will have its priority increase by one
	$ todo bump 3 2  # 3rd will have its priority increase by two
	$ todo bump 3 -2  # 3rd will have its priority decrease by two

Bump with +/-

	$ todo bump 3 +++ # 3rd will have its priority increase by three
	$ todo bump 3 --  # 3rd will have its priority increase by two
	$ todo bump 3 -- ++ -- ++ # 3rd will have its priority increase by zero

Clear done todos
	
	$ todo clear

Create per project/folder list instead of using home list. This list will be available from all subdirectories of the project/folder.

	#from $HOME/my_project
	$ todo init
	$ todo add Start a new project
	
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/vannell/todo/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
