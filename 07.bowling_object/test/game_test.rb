# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/bowling'

class GameTest < MiniTest::Test
  def test_total_socre1
    shots = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 9, 1, 8, 0, 10, 6, 4, 5]
    g = Game.new(shots)
    assert_equal 139, g.total_score
  end

  def test_total_socre2
    shots = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 9, 1, 8, 0, 10, 10, 10, 10]
    g = Game.new(shots)
    assert_equal 164, g.total_score
  end

  def test_total_socre3
    shots = [0, 10, 1, 5, 0, 0, 0, 0, 10, 10, 10, 5, 1, 8, 1, 0, 4]
    g = Game.new(shots)
    assert_equal 107, g.total_score
  end

  def test_total_socre4
    shots = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 9, 1, 8, 0, 10, 10, 0, 0]
    g = Game.new(shots)
    assert_equal 134, g.total_score
  end

  def test_total_socre5
    shots = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 9, 1, 8, 0, 10, 10, 1, 8]
    g = Game.new(shots)
    assert_equal 144, g.total_score
  end

  def test_total_socre6
    shots = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
    g = Game.new(shots)
    assert_equal 300, g.total_score
  end
end
