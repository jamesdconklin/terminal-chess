require_relative 'piece'
require_relative 'slideable'

class Queen < Piece
  include Slideable

  def initialize(color, board, pos)
    @symbol = :Queen
    super
  end

  protected
  def move_dirs()
    [
      [1,1],
      [1,0],
      [1,-1],
      [-1,1],
      [-1,0],
      [-1,-1],
      [0,1],
      [0,-1]
    ]
  end
end
