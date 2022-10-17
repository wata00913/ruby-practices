# frozen_string_literal: true

class Frame
  MAX_PINS = 10

  def initialize(shots)
    @shots = shots
  end

  def score
    @shots.sum
  end

  def to_shots
    @shots.clone
  end

  def spare?
    !strike? && score == MAX_PINS
  end

  def strike?
    @shots.first == MAX_PINS
  end
end
