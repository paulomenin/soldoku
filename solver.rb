require 'grid.rb'

class Solver
	attr_accessor :solutions, :puzzle
	def initialize(puzzle)
		@puzzle = puzzle
		@solutions = nil
	end

	def unique?
		return true if @solutions == 1
		return false
	end
end
