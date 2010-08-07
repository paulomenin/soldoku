def mda(width,height)
	Array.new(width).map! { Array.new(height) }
end

class Cell
	attr_accessor :value, :zones, :is_valid
	def initialize
		@value = '-'
		@is_valid = false
		@zones = []
		@annotations = []
	end
end

class Puzzle
	attr_accessor :cells, :history
	def initialize
		@history = []
		@cells = mda(9,9)

		9.times { |i|
			9.times { |j|
				@cells[i][j] = Cell.new
				@cells[i][j].zones << "col#{i+1}"
				@cells[i][j].zones << "row#{j+1}"
				@cells[i][j].zones << "box1" if (0..2).include?(i) and (0..2).include?(j)
				@cells[i][j].zones << "box2" if (3..5).include?(i) and (0..2).include?(j)
				@cells[i][j].zones << "box3" if (6..8).include?(i) and (0..2).include?(j)
				@cells[i][j].zones << "box4" if (0..2).include?(i) and (3..5).include?(j)
				@cells[i][j].zones << "box5" if (3..5).include?(i) and (3..5).include?(j)
				@cells[i][j].zones << "box6" if (6..8).include?(i) and (3..5).include?(j)
				@cells[i][j].zones << "box7" if (0..2).include?(i) and (6..8).include?(j)
				@cells[i][j].zones << "box8" if (3..5).include?(i) and (6..8).include?(j)
				@cells[i][j].zones << "box9" if (6..8).include?(i) and (6..8).include?(j)
			}	
		}

		@bt_track_state = []
	end

	def solved?
		9.times { |i|
			9.times { |j|
				return false if not @cells[i][j].is_valid
			}
		}
		return true
	end

	def possible?(x, y, value)
		@cells[x][y].zones.each { |zone|
			9.times { |i|
				9.times { |j|
					if @cells[i][j].zones.include? zone
						return false if @cells[i][j].value == value
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
				print "#{@cells[i][j].value} "
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
		#print solved? ? " SOLVED\n" : "\n"
	end

	def read_from_kbd
		i = 0
		while i < 9 do
			j = 0
			while j < 9 do
				print "input[#{i+1},#{j+1}]:"
				value = gets.chomp
				if ['1','2','3','4','5','6','7','8','9'].include? value[0]
					if possible?(i, j, value[0])
						@cells[i][j].value = value[0]
						@cells[i][j].is_valid = true
						print_state
						j += 1
					end
				end
				j += 1 if value[0] == '-'
				i = j = 9 if value == "end"
			end
			i += 1
		end
	end
	
	def bt_first_state
		9.times {|i| 9.times { |j|
			if not (@cells[i][j].is_valid)
				9.times {|value|
					if possible?(i,j,(value+1).to_s)
						@bt_track_state << [i,j,value+1]
						@cells[i][j].value = (value+1).to_s
						@cells[i][j].is_valid = true
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
		@cells[last[0]][last[1]].value = '-'
		@cells[last[0]][last[1]].is_valid = false
		@bt_track_state.pop
		last = @bt_track_state.last
		return false if last == nil
		return true if bt_next_value
		return bt_backtrack
	end

	def bt_next_value
		last = @bt_track_state.last
		last[2] += 1
		while last[2] < 10 and not possible?(last[0],last[1],last[2].to_s)
			last[2] += 1
		end 
		if last[2] < 10
			@cells[last[0]][last[1]].value = (last[2]).to_s
			return true
		end
		return false
	end

	def bt_next_state
		return true if bt_first_state
		return true if bt_next_value
		return bt_backtrack
	end

	def solve_by_backtracking
		@bt_track_state.clear
		count = 0
		while bt_next_state
			if solved?
				count += 1
				print_state
			end
		end
		count
	end

end


file = File.open("test.txt","r")
values = []
count_puzzle = 0;
while not file.eof?
	puzzle = Puzzle.new
	count_puzzle += 1

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
					value = '0'
					invalid_puzzle = true
				end
			end
			if ['1','2','3','4','5','6','7','8','9'].include? value[0]
				if puzzle.possible?(i, j, value[0])
					puzzle.cells[i][j].value = value[0]
					puzzle.cells[i][j].is_valid = true
					j += 1
				end
			end
			j += 1 if value[0] == '-'
			i = j = 9 if value == "end"
		end
		i += 1
	end

	next if invalid_puzzle
	print "\nPuzzle ##{count_puzzle}\n\n"
	puzzle.print_state
	solutions = puzzle.solve_by_backtracking
	if solutions > 0
		print "Number of solutions: #{solutions}\n"
	else
		print "No Solution found!\n"
	end
end
