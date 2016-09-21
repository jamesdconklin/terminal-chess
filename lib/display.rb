require "colorize"
require_relative 'board.rb'
require_relative 'cursor.rb'

class Display
  attr_reader :cursor, :board
  private
  attr_reader :notifications, :current_player
  public

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], @board)
    @notifications = Array.new
  end

  def push_notification(str)
    notifications << str
  end

  def swap_player(color)
    @current_player = color
  end

  def move(start_pos, end_pos)
    @board.move_piece(@current_player, start_pos, end_pos)
  end

  def handle_turn
    @notifications.push("#{@current_player} to play...")
    if @board.in_check?(@current_player)
      @notifications.push("#{current_player} is in check")
    end
    render
    until (start_pos = @cursor.get_input)
      render
    end
    until (end_pos = @cursor.get_input)
      render
    end
    move(start_pos, end_pos)
  rescue InvalidMoveError => ime
    push_notification(ime.message)
    retry
  end


  def render
    system("clear")
    alphabet = ('A'..'Z').to_a
    puts "   #{(0...@board.grid.first.count).map{|idx| alphabet[idx]}.join('  ')}"
    @board.grid.each.with_index do |row, idy|
      print "#{idy} "
      row.each.with_index do |piece, idx|
        color = cursor_pos == [idy,idx] ? :blue : ((idy + idx).even? ? :red : :black)
        print "#{piece.to_s}".colorize(background: color)
      end
      puts
    end
    puts
    @notifications.last(5).each do |note|
      puts note
    end
    puts
    nil
  end

  #Timesaver
  def cursor_pos
    @cursor.cursor_pos
  end

end
