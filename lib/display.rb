require "colorize"
require_relative 'board.rb'
require_relative 'cursor.rb'

class Display
  attr_reader :cursor, :board
  private
  attr_reader :notifications
  public

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], @board)
    @notifications = Hash.new
  end


  def render
    alphabet = ('A'..'Z').to_a
    puts "   #{(0...@board.grid.first.count).map{|idx| alphabet[idx]}.join('  ')}"
    @board.grid.each.with_index do |row, idy|
      print "#{idy} "
      row.each.with_index do |piece, idx|
        color = cursor_pos == [idy,idx] ? :yellow : ((idy + idx).even? ? :red : :blue)
        print "#{"[".colorize(color)}#{piece.to_s}#{"]".colorize(color)}"
      end
      puts
    end
    puts
    nil
  end

  def test
    while true
      system("clear")
      render
      @cursor.get_input
    end
  end
  #Timesaver
  def cursor_pos
    @cursor.cursor_pos
  end

end
