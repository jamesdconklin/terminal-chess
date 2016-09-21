require 'byebug'
module Steppable
  def moves
    # debugger
    y, x = @pos
    raw = move_diffs.map {|y_diff, x_diff| [y + y_diff, x + x_diff]}
    raw.select do |pos|
      piece = @board[pos] if pos.min >= 0 && pos.max < 8
      piece && (piece.empty? || piece.color != @color)
    end

  end
end
