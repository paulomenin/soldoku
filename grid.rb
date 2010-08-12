class Cell
	attr_accessor :value, :is_valid, :is_clue, :zones
	def initialize
		@value = nil
		@is_valid = false
		@is_clue = false
		@zones = []
	end
end

class Grid
	attr_accessor :is_valid
	attr_reader :cells, :symbols, :zones
	def initialize
		@cells = []
		@symbols = []
		@zones = []
		@is_valid = false # TODO review this property
	end

	def solved?
		@cells.each { |cell|
			return false if not cell.is_valid
		}
		return true
	end

	def possible?(cell, value)
		cell.zones.each { |zone|
			@cells.each { |c|
				if c.zones.include? zone
					return false if c.value == value
				end
			}
		}
		return true
	end

end

class ClassicGrid < Grid
	def initialize
		super()
		@grid = Array.new(9).map! { Array.new(9) }
		@symbols = ['1','2','3','4','5','6','7','8','9']
		@zones = ['col1','col2','col3','col4','col5','col6','col7','col8','col9',\
		          'row1','row2','row3','row4','row5','row6','row7','row8','row9',\
		          'box1','box2','box3','box4','box5','box6','box7','box8','box9']
		9.times { |i|
			9.times { |j|
				@grid[i][j] = Cell.new
				@cells << @grid[i][j]
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

	def load_from_file(file)
		values = []
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
						value = :break
						invalid_puzzle = true
					end
				end
				if ['1','2','3','4','5','6','7','8','9'].include? value[0]
					if possible?(@grid[i][j], value[0])
						@grid[i][j].value = value[0]
						@grid[i][j].is_valid = true
						@grid[i][j].is_clue = true
						j += 1
					end
				end
				j += 1 if value[0] == '-'
				i = j = 9 if value == "end"
			end
			i += 1
		end
		@is_valid = true if not invalid_puzzle
	end

	def print_state
		print "+-------+-------+-------+\n"
		for i in 0..8 do
			print "| "
			for j in 0..8 do
				if @grid[i][j].value
					print "#{@grid[i][j].value} "
				else
					print '- ' 
				end
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

