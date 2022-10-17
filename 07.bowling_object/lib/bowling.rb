# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

module Bowling
  MAX_PINS = 10
  MAX_FRAME = 10
  STRIKE_CHAR = 'X'

  def self.convert_to_i(str_num_or_char)
    str_num_or_char == STRIKE_CHAR ? MAX_PINS : str_num_or_char.to_i
  end
end

autoload :Game, 'bowling/game'
autoload :Frame, 'bowling/frame'

def print_game_score
  shots = parse(ARGV[0])
  game = Game.new(shots)

  puts game.total_score
end

def parse(input)
  input.split(',').map { |s| Bowling.convert_to_i(s) }
end

print_game_score if $PROGRAM_NAME == __FILE__
