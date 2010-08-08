require 'grid.rb'

class Solver
	attr_accessor :solutions, :puzzle
	def initialize(puzzle)
		@puzzle = Marshal.load(Marshal.dump(puzzle))
		@solutions = nil
	end

	def unique?
		return true if @solutions.length == 1
		return false
	end
end
