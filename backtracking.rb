require 'solver.rb'

class BacktrackingSolver < Solver
	def initialize(puzzle)
		super(puzzle)
		@bt_track_state = []
	end

	def solve
		return nil if not @puzzle
		@bt_track_state.clear
		while bt_next_state
			if @puzzle.solved?
				@solutions = 0 if not @solutions
				@solutions += 1
				@puzzle.print_state
			end
		end
	end

	private

	def bt_first_state
		9.times {|i| 9.times { |j|
			if not (@puzzle.grid[i][j].is_valid)
				9.times {|value|
					if @puzzle.possible?(i,j,(value+1).to_s)
						@bt_track_state << [i,j,value+1]
						@puzzle.grid[i][j].value = (value+1).to_s
						@puzzle.grid[i][j].is_valid = true
						return true
					end
				}
				return false
			end
		}}
		return false
	end

	def bt_backtrack
		last = @bt_track_state.last
		@puzzle.grid[last[0]][last[1]].value = '-'
		@puzzle.grid[last[0]][last[1]].is_valid = false
		@bt_track_state.pop
		last = @bt_track_state.last
		return false if last == nil
		return true if bt_next_value
		return bt_backtrack
	end

	def bt_next_value
		last = @bt_track_state.last
		last[2] += 1
		while last[2] < 10 and not @puzzle.possible?(last[0],last[1],last[2].to_s)
			last[2] += 1
		end 
		if last[2] < 10
			@puzzle.grid[last[0]][last[1]].value = (last[2]).to_s
			return true
		end
		return false
	end

	def bt_next_state
		return true if bt_first_state
		return true if bt_next_value
		return bt_backtrack
	end


end
