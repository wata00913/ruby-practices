# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/bowling'

class GameTest < MiniTest::Test
  def test_total_socre2
    shots = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 9, 1, 8, 0, 10, 10, 10, 10]
    g = Game.new(shots)
    assert_equal 164, g.total_score
  end

  def test_frame_score_when_10th_frame_contains_strike
    shots = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 9, 1, 8, 0, 10, 10, 6, 4]
    g = Game.new(shots)
    assert_equal 150, g.total_score
  end

  def test_frame_score_when_it_is_all_strike
    shots = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
    g = Game.new(shots)
    assert_equal 300, g.total_score
  end
end
