require 'solver.rb'

class HumanStrategySolver < Solver
	def initialize(puzzle)
		super(puzzle)

		# initialize cell annotations
		@possible_grid = Array.new(9).map! { Array.new(9) }
		9.times { |i| 9.times { |j|
			if not @puzzle.grid[i][j].is_clue
				@possible_grid[i][j] = ['1','2','3','4','5','6','7','8','9']
			else
				@possible_grid[i][j] = nil
			end
		}}
	end

	def solve
		return nil if not @puzzle
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
		9.times { |i| 9.times { |j|
			# eliminate annotations
			next if @puzzle.grid[i][j].is_valid
			9.times { |k|
				if @puzzle.grid[i][k].is_valid
					modified = true if @possible_grid[i][j].delete(@puzzle.grid[i][k].value)
				end
				if @puzzle.grid[k][j].is_valid
					modified = true if @possible_grid[i][j].delete(@puzzle.grid[k][j].value)
				end
			}
			col = i-i%3
			row = j-j%3
			(col..col+2).each {|x| (row..row+2).each {|y|
				if @puzzle.grid[x][y].is_valid
					modified = true if @possible_grid[i][j].delete(@puzzle.grid[x][y].value)
				end
			}}

			# verify single candidate
			if @possible_grid[i][j].length == 1
				@puzzle.grid[i][j].value = @possible_grid[i][j][0]
				@puzzle.grid[i][j].is_valid = true
				modified = true;
			end
		}}
		return modified
	end

end
