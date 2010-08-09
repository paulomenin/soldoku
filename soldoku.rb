require 'grid.rb'
require 'backtrackingsolver.rb'
require 'humanstrategysolver.rb'

class Soldoku
	def initialize

	end

	def run
		solve_from_file("test.txt")
	end

	def solve_from_file(filename)
		file = File.open(filename,"r")
		count_puzzle = 0;
		while not file.eof?
			puzzle = ClassicGrid.new
			puzzle.load_from_file(file)
			
			count_puzzle += 1
			print "\nPuzzle ##{count_puzzle}\n\n"
			if puzzle.is_valid
				puzzle.print_state
			else
				print "Invalid puzzle.\n"
				next
			end

			solver1 = HumanStrategySolver.new(puzzle)
			solver1.solve
			solver = solver1
			solutions = solver1.solutions
			if not solutions
				solver2 = BacktrackingSolver.new(solver.puzzle)
				solver2.solve
				solver = solver2
				solutions = solver2.solutions
			end

			if solutions != nil
				if solver.unique?
					print "Unique solution\n"
					solver.solutions[0].print_state
				else
					print "Number of solutions: #{solver.solutions.length}\n"
					solver.solutions.each {|i| i.print_state}
				end
			else
				print "No Solution found!\n"
			end
		end
	end

end

soldoku = Soldoku.new
soldoku.run
