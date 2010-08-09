require 'solver.rb'

class BacktrackingSolver < Solver
	def initialize(puzzle)
		super(puzzle)
		@bt_track_state = []
	end

	def solve
		@bt_track_state.clear
		while bt_next_state
			if @puzzle.solved?
				@solutions = [] if not @solutions
				@solutions << Marshal.load(Marshal.dump(@puzzle))
			end
		end
	end

	private

	def bt_first_state
		@puzzle.cells.each { |i|
			if not i.is_valid
				9.times {|value|
					if @puzzle.possible?(i,(value+1).to_s)
						@bt_track_state << [i,value+1]
						i.value = (value+1).to_s
						i.is_valid = true
						return true
					end
				}
				return false
			end
		}
		return false
	end

	def bt_backtrack
		last = @bt_track_state.last
		last[0].value = nil
		last[0].is_valid = false
		@bt_track_state.pop
		last = @bt_track_state.last
		return false if last == nil
		return true if bt_next_value
		return bt_backtrack
	end

	def bt_next_value
		last = @bt_track_state.last
		last[1] += 1
		while last[1] < 10 and not @puzzle.possible?(last[0],last[1].to_s)
			last[1] += 1
		end 
		if last[1] < 10
			last[0].value = (last[1]).to_s
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
