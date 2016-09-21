require_relative 'piece'

class Pawn < Piece
  def initialize(color, board, pos)
    @symbol = :pawn
    super
  end

  def moves
    forward_steps + side_attack
  end

  protected

  def at_start_row?
    rank = color == :black ? 1 : 6
    @pos.first == rank
  end

  def forward_steps
    advance = []
    steps = at_start_row? ? 2 : 1
    pos_walker = @pos
    steps.times do
      pos_walker = self.class.pos_add(pos_walker, forward_dir)
      pos_piece = @board[pos_walker]
      break unless pos_piece && pos_piece.empty?
      advance << pos_walker
    end
    advance
  end

  def forward_dir
    @color == :black ? [1,0] : [-1,0]
  end

  def side_attack
    raw = [[0,-1], [0,1]].map do |lateral|
      self.class.pos_add(lateral, forward_dir, @pos)
    end

    ret = raw.select do |pos|
      piece = @board[pos]
      piece && !piece.empty? && piece.color != @color
    end
    ret
  end

  private
  def self.pos_add(*arrs)
    arrs.inject([0,0]) do |accum, arr|
      [accum.first + arr.first, accum.last + arr.last]
    end
  end
end
