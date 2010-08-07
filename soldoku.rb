require 'puzzle.rb'

class Soldoku
	def initialize

	end

	def run
		file = File.open("test.txt","r")
		values = []
		count_puzzle = 0;
		while not file.eof?
			puzzle = Puzzle.new
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
							puzzle.cells[i][j].value = value[0]
							puzzle.cells[i][j].is_valid = true
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
			solutions = puzzle.solve_by_backtracking
			if solutions > 0
				print "Number of solutions: #{solutions}\n"
			else
				print "No Solution found!\n"
			end
		end
	end
end

soldoku = Soldoku.new
soldoku.run
