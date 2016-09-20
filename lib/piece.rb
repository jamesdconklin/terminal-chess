require 'singleton'

class Piece
  attr_reader :color, :Board
  attr_accessor :pos

  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
  end

  def to_s
    #abstract
  end

  def empty?
    false
  end

  def symbol
  end

  def valid_moves
  end

  private
  def move_into_check?(to_pos)
  end

end

class NullPiece < Piece
  include Singleton

  def color
    nil
  end

  def to_s
    ' '
  end

  def empty?
    true
  end

end
