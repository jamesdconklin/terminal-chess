require_relative 'board'
require_relative 'display'

class Game
  attr_reader :players, :board, :display

  def initialize()
    @board = Board.new()
    @display = Display.new(board)
    @players = [:white, :black]
  end

  def current_player
    @players.first
  end

  def play
    while true
      break if @board.checkmate?(current_player)
      @display.swap_player(current_player)
      @display.handle_turn
      swap_turn!
    end
    swap_turn!
    @display.push_notification("#{current_player} has won!")
    @display.render

  end

  private
  def swap_turn!
    @players.rotate!
  end

end


if __FILE__ == $PROGRAM_NAME
  game = Game.new()
  game.play
end
