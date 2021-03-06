require_relative "./piece"
require_relative "./constants"

module Chess
  class Pawn < Piece
    def initialize(color, position, board)
      super(color, position, board)
      @direction = ((position[0] == 1) ? :+ : :-)
      @moved = false
    end

    def moves
      cardinal_moves + diagonal_moves
    end

    def position=(pos)
      @moved = true
      super(pos)
    end

    def to_s
      (color == :white) ? Constants::PAWN_WHITE : Constants::PAWN_BLACK
    end


    private

    def cardinal_moves
      moves_array = []
      new_position = [position[0].send(@direction, 1), position[1]]

      if board.on_board?(new_position) && !board.position_occupied?(new_position)
        moves_array << new_position
        next_position = [new_position[0].send(@direction, 1), new_position[1]]
        if !@moved && !board.position_occupied?(new_position) &&
          (board.on_board?(next_position) && !board.position_occupied?(next_position))
          moves_array << next_position
        end
      end

      moves_array
    end

    def diagonal_moves
      moves_array = []
      diagonal_positions = [[position[0].send(@direction, 1), position[1] - 1],
                            [position[0].send(@direction, 1), position[1] + 1]]
      diagonal_positions.each do |diagonal_position|
        if board.on_board?(diagonal_position) &&
          board.position_occupied_by_color?(diagonal_position, opponent_color)
          moves_array << diagonal_position
        end
      end

      moves_array
    end
  end
end