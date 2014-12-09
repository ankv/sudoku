module Sudoku
  class SudokuInvalidInput < Exception
  end

  class SudokuReader
    def self.gets(ios)
      arr = ios.readline.split(" ")
      raise SudokuInvalidInput.new("Incomplete Input") if arr.size < 3
      arr.map! { |element| element.to_i }
      raise SudokuInvalidInput.new("Out Of Range") if arr.select { |element| not element.between?(1,9) }.size > 0
      arr
    end
  end

  class Engine 
    attr_accessor :board
    def initialize(input = STDIN)
      @input_stream = input
      @board = [[2,8,0,0,0,4,3,5,1],[6,0,0,0,0,0,7,8,4],[0,4,1,8,0,0,0,0,9],[0,0,8,3,9,0,5,4,6],
                [0,0,5,6,0,0,2,0,8],[0,6,0,5,1,0,9,7,3],[9,0,0,0,8,6,4,3,0],[5,0,0,9,7,0,0,0,2],[0,0,0,4,0,0,0,0,0]]
      @fixed_cells = @board.collect { |row| row.collect { |column| column } }
      @error_message = ""
    end

    def draw
      system("clear")
      9.times { |row| p @board[row] }
    end

    def overwrite_fixed_cell?(row, column)
      !@fixed_cells[row][column].eql?(0)
    end

    def process()
      puts "Enter row column value " + @error_message
      row, column, value = SudokuReader.gets(@input_stream)
      raise SudokuInvalidInput.new("You can't overwrite a fixed cell") if overwrite_fixed_cell?(row-1, column-1)
      @board[row-1][column-1] = value 
    end

    def not_valid_rows?(temp_board)
      9.times do |row|
        return true if (!temp_board[row].uniq.size.eql?(9))
      end
      false 
    end

    def not_solved?
      return true if not_valid_rows?(@board) and not_valid_rows?(@board.transpose) 
      column, row = 0, 0
      9.times do |i|
        temp_row = @board[row][column..column_2]
        temp_row = temp + @board[row+1][column..column+2]
        temp_row = temp = @board[row+2][column..column+2]
        if temp_row.uniq.size.eql?(9) then
          return true
        end
        column += 3
        column %= 9
        if column.eql?(6) then row += 3 end
      end
      false
    end

    def start
      while not_solved? do
        begin
          draw
          process
          @error_message = "" # reset error if any
        rescue SudokuInvalidInput => e
          @error_message = " ### Input Error: #{e.message} ###"
          retry
        rescue EOFError => e
          @input_stream.close
          break
        end
      end
    end
  end
end

#game = Sudoku.new
#game = Sudoku.new(File.new("/home/ankit/Desktop/input.txt"))
#game.start_game
