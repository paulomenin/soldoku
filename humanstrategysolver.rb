require 'solver.rb'

class HumanStrategySolver < Solver
	def initialize(puzzle)
		super(puzzle)

		# initialize cell annotations
		@possible_cells = Array.new(@puzzle.cells.length)
		(0..@possible_cells.length-1).each { |i|
			if not @puzzle.cells[i].is_clue
				@possible_cells[i] = @puzzle.symbols.clone
			else
				@possible_cells[i] = nil
			end
		}
	end

	def solve
		crbe
		lone_ranger

		if @puzzle.solved?
			@solutions = [] if not @solutions
			@solutions << Marshal.load(Marshal.dump(@puzzle))
		end
	end

	private

	# Column, Row and Box Elimination
	def crbe
		loop {
			modified = false
			modified = true if crbe_inner
			break unless modified
		}
	end

	def crbe_inner
		modified = false
		(0..@puzzle.cells.length-1).each { |i|
			# eliminate annotations
			next if @puzzle.cells[i].is_valid
			
			@puzzle.cells.each { |cell|
				if cell.is_valid
					cell.zones.each { |zone|
						if @puzzle.cells[i].zones.include?(zone)
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

	def lone_ranger
		loop {
			modified = false
			@puzzle.zones.each { |zone|
				modified = true if lone_ranger_inner(zone)
			}
			break unless modified
		}
	end

	def lone_ranger_inner(zone)
		modified = false
		occurences = Array.new(@puzzle.symbols.length, 0)

		(0..@puzzle.cells.length-1).each { |i|
			next if @puzzle.cells[i].is_valid
			if @puzzle.cells[i].zones.include?(zone)
				@possible_cells[i].each { |value|
					occurences[@puzzle.symbols.index(value)] += 1
				}
			end
		}

		unique = []
		(0..occurences.length-1).each { |i|
			next unless occurences[i] == 1
			unique << @puzzle.symbols[i]
		}

		(0..@puzzle.cells.length-1).each { |i|
			next if @puzzle.cells[i].is_valid
			if @puzzle.cells[i].zones.include?(zone)
				match_unique = nil
				unique.each {|symbol|
					match_unique = symbol if @possible_cells[i].include?(symbol)
				}
				if match_unique
					@puzzle.cells[i].value = match_unique
					@puzzle.cells[i].is_valid = true
					modified = true
					remove_possible(@puzzle.cells[i].zones, match_unique)
				end
			end
		}
		return modified
	end

	def remove_possible(zones, symbol)
		(0..@puzzle.cells.length-1).each { |i|
			next if @puzzle.cells[i].is_valid
			match_zone = false
			zones.each { |zone|
				match_zone = true if @puzzle.cells[i].zones.include?(zone)
			}
			if match_zone
				@possible_cells[i].delete(symbol)
			end
		}
	end
end
