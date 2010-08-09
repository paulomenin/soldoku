require 'solver.rb'

class HumanStrategySolver < Solver
	def initialize(puzzle)
		super(puzzle)

		# initialize cell annotations
		@possible_cells = Array.new(@puzzle.cells.length)
		(0..@possible_cells.length-1).each { |i|
			if not @puzzle.cells[i].is_clue
				@possible_cells[i] = ['1','2','3','4','5','6','7','8','9']
			else
				@possible_cells[i] = nil
			end
		}
	end

	def solve
		modified = true
		while modified
			modified = crbe
		end
		if @puzzle.solved?
			@solutions = [] if not @solutions
			@solutions << Marshal.load(Marshal.dump(@puzzle))
		end
	end

	private

	# Column, Row and Box Elimination
	def crbe
		modified = false
		(0..@puzzle.cells.length-1).each { |i|
			# eliminate annotations
			next if @puzzle.cells[i].is_valid
			
			@puzzle.cells.each { |cell|
				if cell.is_valid
					cell.zones.each { |zone|
						if @puzzle.cells[i].zones.include? zone
							modified = true if @possible_cells[i].delete(cell.value)
						end
					}
				end
			}

			# verify single candidate
			if @possible_cells[i].length == 1
				@puzzle.cells[i].value = @possible_cells[i][0]
				@puzzle.cells[i].is_valid = true
				modified = true;
			end
		}
		return modified
	end

end
