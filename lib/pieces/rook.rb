require_relative 'piece'
require_relative 'slideable'

class Rook < Piece
  include Slideable

  def initialize(color, board, pos)
    @symbol = :rook
    super
  end

  protected
  def move_dirs()
    [
      [1,0],
      [0,-1],
      [0,1],
      [-1,0]
    ]
  end
end
