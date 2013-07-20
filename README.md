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

Mark todo as done by its number

	$ todo done 1

Bump todo
	
	$ todo bump todo_id [up = 1]
	$ todo bump 3    # 3rd will become 2nd in order
	$ todo bump 3 2  # 3rd will become 1st in order

Clear done todos
	
	$ todo clear

Create per project/folder list instead of using home list. This list will be available from all subdirectories of the project/folder.

	#from $HOME/my_project
	$ todo init
	$ todo add Start a new project
	

