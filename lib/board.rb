require_relative "piece"
require 'byebug'

class Board
  attr_reader :grid
  def initialize(grid = nil)
    if grid.nil?
      @grid = make_starting_grid
    else
      @grid = self.class.empty_grid
      (0...8).each do |idy|
        (0...8).each do |idx|
          self[[idy,idx]] = grid[idy][idx].dup(self)
        end
      end
    end
   end

  def [](pos)
    @grid[pos.first][pos.last]
  end

  def []=(pos, value)
    # debugger
    @grid[pos.first][pos.last] = value
  end
  #TODO: refactor in_bounds? into other methods.
  def in_bounds?(pos)
    y, x = pos
    return [x,y].max < @grid.count && [x,y].min >= 0
  end

  def move_piece(color, start_pos, end_pos)
    moving_piece = self[start_pos]

    if moving_piece.empty?
      raise NullPieceError.new(start_pos:start_pos)
    end
    unless moving_piece.color == color
      raise WrongColorError.new(star_pos:start_pos)
    end

    staging_board = dup
    staging_board.move_piece!(start_pos, end_pos)

    move_piece!(start_pos, end_pos)
  end

  def dup #Deep duplication of the original board.
    Board.new(@grid)
  end



  def in_check?(color)
    checking_color = color == :black ? :white : :black
    test_board = dup
    king_pos = find_king(color)
    @grid.each do |row|
      row.each do |piece|
        if piece.color == checking_color
          begin
             return test_board.move_piece(checking_color, piece.pos, king_pos)
          rescue InvalidMoveError
            next
          end
        end
      end
    end
    nil
  end

  def get_pieces(color)
    @grid.flatten.select {|piece| piece.color == color}
  end

  def checkmate?(color)
    return false unless in_check?(color)
    test_board = dup
    get_pieces(color).each do |piece|
      piece.moves.each do |targ|
        begin
          result = test_board.move_piece(color, piece.pos, targ)
          return false
        rescue CheckError
          next
        rescue InvalidMoveError => ime
          p ime
          next
        end
      end
    end
    true
  end

  # TODO: Refactor in get_pieces
  def find_king(color)
    king = get_pieces(color).find {|piece| piece.symbol == :King}
    return king && king.pos
  end

  def self.empty_grid
    Array.new(8) {Array.new(8) {NullPiece.instance}}
  end

  def make_starting_grid
    grid = self.class.empty_grid
    grid[0] = home_row(:black, 0)
    grid[7] = home_row(:white, 7)
    (0...8).each do |idx|
      # self.[]=([1,idx], Pawn blah blah)
      grid[1][idx] = Pawn.new(:black, self, [1, idx])
      grid[6][idx] = Pawn.new(:white, self, [6, idx])
    end
    # debugger
    grid
  end

  def home_row(color, idy)
    idx = -1
    row = []
    row << Rook.new(color,self,[idy, idx += 1])
    row << Knight.new(color,self,[idy, idx += 1])
    row << Bishop.new(color,self,[idy, idx += 1])
    row << Queen.new(color,self,[idy, idx += 1])
    row << King.new(color,self,[idy, idx += 1])
    row << Bishop.new(color,self,[idy, idx += 1])
    row << Knight.new(color,self,[idy, idx += 1])
    row << Rook.new(color,self,[idy, idx += 1])
    row
  end


  def move_piece!(start_pos, end_pos)
    if (end_pos.min < 0 || end_pos.max > 7 )
      raise InvalidDestinationError.new(
        message: "Target position is off the board.",
        end_pos: end_pos
      )
    end

    moving_piece = self[start_pos]
    unless moving_piece.moves.include?(end_pos)
      raise InvalidDestinationError.new(
        start_pos: start_pos,
        end_pos: end_pos
      )
    end

    self[start_pos] = NullPiece.instance
    moving_piece.pos = end_pos
    self[end_pos] = moving_piece

    if (check = in_check?(moving_piece.color))
      raise CheckError.new(
        check_pos: check,
        start_pos: start_pos,
        end_pos: end_pos
      )
    end
  start_pos
  end

end


class InvalidMoveError < StandardError
  attr_reader :start_pos, :end_pos, :message
  def initialize(options = {})
    default_options = {
      start_pos: [-1,-1],
      end_pos: [-1,-1],
      message: "Move is invalid."
    }
    default_options.merge!(options)
    @start_pos = default_options[:start_pos]
    @end_pos = default_options[:end_pos]
    @message = default_options[:message]
    super()
  end

end

class NullPieceError < InvalidMoveError
  def initialize(options = {})
    super(options.merge({message: "Null piece cannot be moved."}))
  end
end

class InvalidDestinationError < InvalidMoveError
  def initialize(options = {})
    super(options.merge({message:"Piece cannot reach position."}))
  end
end

class CheckError < InvalidMoveError
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

class WrongColorError < InvalidMoveError
  def initialize(options = {})
    super(options.merge({message:"Cannot move opponent's piece."}))
  end
end
