require_relative "piece"

class Board
  attr_reader :grid
  def initialize
    #TODO: Initialize to null piece instead.
    @grid = make_starting_grid

  def [](pos)
    @grid[pos.first][pos.last]
  end

  #TODO: Specialize this
  def []=(pos, value)
    @grid[pos.first][pos.last] = val
  end
  def in_bounds?(pos)
    y, x = pos
    return [x,y].max < @grid.count && [x,y].min >= 0
  end

  def move_piece(color, start_pos, end_pos)
    moving_piece = self[start_pos]
    if moving_piece.empty?
      raise NullPieceError.new(start_pos:start_pos)
    end

    staging_board = dup
    staging_board.move_piece!(start_pos, end_pos)

    unless moving_piece.color == color
      raise WrongColorError.new(star_pos:start_pos)
    end

    move_piece!(start_pos, end_pos)
    end
  end

  def dup(board) #Deep duplication of the original board.
    grid = []
    @grid.each do |row|
      new_row = []
      row.each do |piece|
        new_row << piece.dup(board)
      end
      grid << new_row
    end
    grid
  end

  protected
  def make_starting_grid
  #TODO: Is this where we place null/functional pieces
    grid = Array.new(8) {Array.new(8) {NullPiece.instance}}
  end



  def move_piece!(start_pos, end_pos)
    if (end_pos.min < 0 || end_pos.max > 7 )
      raise InvalidDestinationError.new(
        message: "Target position is off the board.",
        end_pos: end_pos
      )
    end
    moving_piece = self[start_pos]
    self[start_pos] = NullPiece.instance
    self[end_pos] = moving_piece

    #TODO: Incremental move. (blockers)
    #TODO: Check checking.

  end


end

class BoardException < StandardError
  attr_reader :start_pos, :end_pos
  def initialize(options = {})
    default_options = {
      start_pos: [-1,-1],
      end_pos: [-1,-1], #So that we know that the values that are returned are defaults.
      message: "Board exception occurred"
    }

    default_options.merge!(options)
    @start_pos = default_options[:start_pos]
    @end_pos = default_options[:end_pos]
    super(default_options[:message])
  end
end

class NullPieceError < BoardException
  def initialize(options = {})
    super(options.merge({message: "Null piece cannot be moved."}))
  end
end

class InvalidMoveError < BoardException
  def initialize(options = {})
    super(options.merge({message: "Move is invalid."}))
  end
end

class BlockedMoveError < InvalidMoveError
  attr_reader :block_pos
  def initialize(options = {})
    default_options = {
      block_pos: [0,0]
    }.merge(options)
    @block_pos = default_options[:block_pos]
    message = "Move blocked by piece at #{@block_pos}"
    super(default_options.merge({message:message}))
  end
end

class InvalidDestinationError < InvalidMoveError
  def initialize(options = {})
    super(options.merge({message:"Piece cannot reach position."}))
  end
end

class InducedCheckError < InvalidMoveError
  attr_reader :check_pos
  def initialize(options = {})
    default_options = {
      check_pos: [0,0]
    }.merge(options)
    @check_pos = default_options[:check_pos]
    message = "Move induces check from #{@check_pos}"
    super(default_options.merge({message:message}))
  end
end

class WrongColorException < InvalidMoveError
  def initialize(options = {})
    super(options.merge({message:"Cannot move opponent's piece."}))
  end
end
