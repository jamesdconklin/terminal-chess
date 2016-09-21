require 'singleton'

class Piece
  attr_reader :color, :board, :symbol
  attr_accessor :pos

  @@SYMBOL_MAP = {
    King: { black: "\u265a", white: "\u2654"},
    Queen: {black: "\u265b", white: "\u2655"},
    rook: {black: "\u265c", white: "\u2656"},
    bishop: {black: "\u265d", white: "\u2657"},
    pawn: {black: "\u265f", white: "\u2659"},
    knight: {black: "\u265e", white: "\u2658"}
  }



  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
  end

  def move_piece(pos)
    @pos = pos
  end


  def to_s
    " #{@@SYMBOL_MAP[@symbol][@color]} "
  end

  def empty?
    false
  end

  def valid_moves
  end

  def dup(board)
    case @symbol
    when :knight
      return Knight.new(@color, board, @pos)
    when :King
      return King.new(@color, board, @pos)
    when :Queen
      return Queen.new(@color, board, @pos)
    when :rook
      return Rook.new(@color, board, @pos)
    when :pawn
      return Pawn.new(@color, board, @pos)
    when :bishop
      return Bishop.new(@color, board, @pos)
    end
  end

end

class NullPiece
  include Singleton

  def color
    nil
  end

  def dup(*arg)
    self.class.instance
  end

  def to_s
    '   '
  end

  def empty?
    true
  end

end
