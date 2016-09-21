require_relative 'piece'
require_relative 'steppable'

class Knight < Piece
  include Steppable

  def initialize(color, board, pos)
    @symbol = :knight
    super
  end

  protected
  def move_diffs()
    knight_moves = []
    [2, -2].each do |big|
      [1, -1].each do |small|
        knight_moves << [big, small] << [small, big]
      end
    end
    knight_moves
  end
end
