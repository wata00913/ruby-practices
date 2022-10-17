# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

module Bowling
  MAX_PINS = 10
  MAX_FRAME = 10
end

STRIKE_CHAR = 'X'

autoload :Game, 'bowling/game'
autoload :Frame, 'bowling/frame'

def print_game_score
  shots = parse(ARGV[0])
  game = Game.new(shots)

  puts game.total_score
end

def parse(input)
  input.split(',').map do |c|
    if c == STRIKE_CHAR
      Bowling::MAX_PINS
    else
      c.to_i
    end
  end
end

print_game_score if $PROGRAM_NAME == __FILE__
