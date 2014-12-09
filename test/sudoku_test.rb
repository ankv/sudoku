require 'test_helper'
require 'stringio'

describe Sudoku::Engine do
  before do
  end

  describe ".overwrite_fixed_cell?" do
    it "returns true for input 1 2" do
      suduko = Sudoku::Engine.new
      suduko.overwrite_fixed_cell?(0,1).must_equal true
    end

    it "returns false for input 1 3" do
      suduko = Sudoku::Engine.new
      suduko.overwrite_fixed_cell?(0,2).must_equal false
    end
  end

  describe ".process" do
    it "raise exception [cannot modify fixed cells] for input 1 1 9" do
      input = StringIO.new("1 1 9\n")
      suduko = Sudoku::Engine.new(input)
      err = -> {suduko.process}.must_raise Sudoku::SudokuInvalidInput
      err.message.must_match "You can't overwrite a fixed cell"
    end
    it "returns 5 for input 1 3 5" do
      input = StringIO.new("1 3 5\n")
      suduko = Sudoku::Engine.new(input)
      suduko.process().must_equal 5
    end
  end

  describe ".not_valid_rows?" do
    it "returns true for input test_board" do
      test_board = [[2,8,0,0,0,4,3,5,1],[6,0,0,0,0,0,7,8,4],[0,4,1,8,0,0,0,0,9],[0,0,8,3,9,0,5,4,6],
              [0,0,5,6,0,0,2,0,8],[0,6,0,5,1,0,9,7,3],[9,0,0,0,8,6,4,3,0],[5,0,0,9,7,0,0,0,2],[0,0,0,4,0,0,0,0,0]]
      suduko = Sudoku::Engine.new
      suduko.not_valid_rows?(test_board).must_equal true
    end

    it "returns false for input test_board" do
      test_board = [[1,2,3,4,5,6,7,8,9],[9,1,2,3,4,5,7,6,8],[8,9,1,2,3,4,5,6,7],[7,8,9,1,2,3,4,5,6],
              [6,7,8,9,1,2,3,4,5],[5,6,7,8,9,1,2,3,4],[4,5,6,7,8,9,1,2,3],[3,4,5,6,7,8,9,1,2],[2,3,4,5,6,7,8,9,1]]
      suduko = Sudoku::Engine.new
      suduko.not_valid_rows?(test_board).must_equal false
    end
  end

  describe ".not_solved?" do
    it "returns false for .board" do
      suduko = Sudoku::Engine.new
      suduko.board = [[8,8,7,1,5,4,3,9,6],[9,6,5,3,2,7,1,4,8],[3,4,1,6,8,9,7,5,2],
       [5,9,3,4,6,8,2,7,1],[4,7,2,5,1,3,6,8,9],[6,1,8,9,7,2,4,3,5],
       [7,8,6,2,3,5,9,1,4],[1,5,4,7,9,6,8,2,3],[2,3,9,8,4,1,5,6,7]]
      suduko.not_solved?.must_equal true
    end
    it "returns true for .board" do
      suduko = Sudoku::Engine.new
      suduko.board = [[8,2,7,1,5,4,3,9,6],[9,6,5,3,2,7,1,4,8],[3,4,1,6,8,9,7,5,2],
       [5,9,3,4,6,8,2,7,1],[4,7,2,5,1,3,6,8,9],[6,1,8,9,7,2,4,3,5],
       [7,8,6,2,3,5,9,1,4],[1,5,4,7,9,6,8,1,3],[2,3,9,8,4,1,5,6,7]]
      suduko.not_solved?.must_equal true
    end
    it "returns true for .board" do
      suduko = Sudoku::Engine.new
      suduko.board = [[8,2,7,1,5,4,3,9,6],[9,6,5,3,2,7,1,4,8],[3,4,1,6,8,9,7,5,2],
       [5,9,3,4,6,8,2,7,1],[4,7,2,5,1,3,6,8,9],[6,1,8,9,7,2,4,3,5],
       [7,8,6,2,3,5,9,1,4],[1,5,4,7,9,6,8,2,3],[2,3,9,8,4,1,5,6,7]]
      suduko.not_solved?.must_equal true
    end
  end

  describe "Sudoku::SudokuReader.gets" do
    it "returns [1, 2, 3] for input 1 2 3" do
      input = StringIO.new("1 2 3\n")
      Sudoku::SudokuReader.gets(input).must_equal [1,2,3]
    end
    it "returns [1, 2, 3] for input 1 2 3 4 5" do
      input = StringIO.new("1 2 3 4 5\n")
      Sudoku::SudokuReader.gets(input).must_equal [1,2,3]
    end
    it "returns [1, 2, 3] for input 1 2 3 34 5342 234 sjfskjfskjf" do
      input = StringIO.new("1 2 3 34 5342 234 sjfskjfskjf\n")
      Sudoku::SudokuReader.gets(input).must_equal [1,2,3]
    end
    it "raise exception [Invalid input] for input 1 2" do
      input = StringIO.new("1 2\n")
      err = -> {Sudoku::SudokuReader.gets(input)}.must_raise Sudoku::SudokuInvalidInput
      err.message.must_match "Incomplete Input"
    end
    it "raise exception [Invalid input] for input 1 2 10" do
      input = StringIO.new("1 2 10\n")
      err = -> {Sudoku::SudokuReader.gets(input)}.must_raise Sudoku::SudokuInvalidInput
      err.message.must_match "Out Of Range"
    end
    it "raise exception [Invalid input] for input 1 10 2 2 3" do
      input = StringIO.new("1 10 2 2 3\n")
      err = -> {Sudoku::SudokuReader.gets(input)}.must_raise Sudoku::SudokuInvalidInput
      err.message.must_match "Out Of Range"
    end
    it "raise exception [Invalid input] for input jsfkds sdjfsd fksdjf" do
      input = StringIO.new("jsfkds sdjfsd fksdjf\n")
      err = -> {Sudoku::SudokuReader.gets(input)}.must_raise Sudoku::SudokuInvalidInput
      err.message.must_match "Out Of Range"
    end
    it "raise exception [Invalid input] for input " do
      input = StringIO.new("\n")
      err = -> {Sudoku::SudokuReader.gets(input)}.must_raise Sudoku::SudokuInvalidInput
      err.message.must_match "Incomplete Input"
    end
  end
end
