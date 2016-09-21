module Slideable
  def moves
    sliding_moves = []
    move_dirs.each do |dir|
      sliding_moves.concat(grow_unblocked_moves_in_dir(*dir))
    end
    sliding_moves
  end

  private

  def grow_unblocked_moves_in_dir(dy, dx)
    unblocked = []
    pos_walker = step(@pos, [dy,dx])

    while (pos_walker.min >= 0 && pos_walker.max < 8 &&
           piece = @board[pos_walker])  
      if piece.empty? || piece.color != @color
        unblocked << pos_walker
      end
      pos_walker = step(pos_walker, [dy,dx])
      return unblocked unless piece.empty?
    end
    unblocked
  end

  def step(pos, diff)
    [pos.first + diff.first, pos.last + diff.last]
  end
end
