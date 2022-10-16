# frozen_string_literal: true

class Frame
  MAX_PINS = 10

  def initialize(shots)
    @shots = shots
  end

  def score
    @shots.sum
  end

  def bonus_score(type)
    case type
    when :spare
      @shots.first
    when :strike
      score
    end
  end

  def spare?
    !strike? && score == MAX_PINS
  end

  def strike?
    @shots.first == MAX_PINS
  end
end
