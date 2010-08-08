class Cell
	attr_accessor :value, :is_valid, :is_clue, :zones
	def initialize
		@value = '-'
		@is_valid = false
		@is_clue = false
		@zones = []
		@annotations = []
	end
end

class ClassicGrid
	attr_accessor :grid
	def initialize
		@grid = Array.new(9).map! { Array.new(9) }

		9.times { |i|
			9.times { |j|
				@grid[i][j] = Cell.new
				@grid[i][j].zones << "col#{i+1}"
				@grid[i][j].zones << "row#{j+1}"
				@grid[i][j].zones << "box1" if (0..2).include?(i) and (0..2).include?(j)
				@grid[i][j].zones << "box2" if (3..5).include?(i) and (0..2).include?(j)
				@grid[i][j].zones << "box3" if (6..8).include?(i) and (0..2).include?(j)
				@grid[i][j].zones << "box4" if (0..2).include?(i) and (3..5).include?(j)
				@grid[i][j].zones << "box5" if (3..5).include?(i) and (3..5).include?(j)
				@grid[i][j].zones << "box6" if (6..8).include?(i) and (3..5).include?(j)
				@grid[i][j].zones << "box7" if (0..2).include?(i) and (6..8).include?(j)
				@grid[i][j].zones << "box8" if (3..5).include?(i) and (6..8).include?(j)
				@grid[i][j].zones << "box9" if (6..8).include?(i) and (6..8).include?(j)
			}	
		}
	end

	def solved?
		9.times { |i|
			9.times { |j|
				return false if not @grid[i][j].is_valid
			}
		}
		return true
	end

	def possible?(x, y, value)
		@grid[x][y].zones.each { |zone|
			9.times { |i|
				9.times { |j|
					if @grid[i][j].zones.include? zone
						return false if @grid[i][j].value == value
					end
				}
			}
		}
		return true
	end

	def print_state
		print "+-------+-------+-------+\n"
		for i in 0..8 do
			print "| "
			for j in 0..8 do
				print "#{@grid[i][j].value} "
				if (j < 6) and (j%3 == 2)
					print '| '
				end
			end
			print "|\n"
			if (i < 6) and (i%3 == 2)
				print "+-------+-------+-------+\n"
			end
		end
		print "+-------+-------+-------+\n"
	end

end

