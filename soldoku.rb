require 'grid.rb'
require 'backtracking.rb'

class Soldoku
	def initialize

	end

	def run
		file = File.open("test.txt","r")
		values = []
		count_puzzle = 0;
		while not file.eof?
			puzzle = ClassicGrid.new
			count_puzzle += 1
			i = 0
			while i < 9 do
				j = 0
				while j < 9 do
					value = values.shift
					while value == nil
						values = file.readline.split ' '
						value = values.shift
						if file.eof?
							i = j = 9
							value = '0'
							invalid_puzzle = true
						end
					end
					if ['1','2','3','4','5','6','7','8','9'].include? value[0]
						if puzzle.possible?(i, j, value[0])
							puzzle.grid[i][j].value = value[0]
							puzzle.grid[i][j].is_valid = true
							puzzle.grid[i][j].is_clue = true
							j += 1
						end
					end
					j += 1 if value[0] == '-'
					i = j = 9 if value == "end"
				end
				i += 1
			end

			next if invalid_puzzle
			print "\nPuzzle ##{count_puzzle}\n\n"
			puzzle.print_state
			solver = BacktrackingSolver.new(puzzle)
			solver.solve
			if solver.solutions != nil
				if solver.unique?
					print "Unique solution\n"
				else
					print "Number of solutions: #{solver.solutions}\n"
				end
			else
				print "No Solution found!\n"
			end
		end
	end
end

soldoku = Soldoku.new
soldoku.run
