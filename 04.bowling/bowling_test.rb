# frozen_string_literal: true

require 'minitest/autorun'
require_relative './bowling'

class BowlingTest < Minitest::Test
  def test_to_scores_per_frame
    input = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 'X', 9, 1, 8, 0, 'X', 6, 4, 5]
    expected = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], ['X'], [9, 1], [8, 0], ['X'], [6, 4, 5]]
    assert_equal expected, to_scores_per_frame(input)
  end

  def test_to_scores_per_frame_when_10th_frame_is_turkey
    input = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 'X', 9, 1, 8, 0, 'X', 'X', 'X', 'X']
    expected = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], ['X'], [9, 1], [8, 0], ['X'], %w[X X X]]
    assert_equal expected, to_scores_per_frame(input)
  end

  def test_to_scores_per_frame_when_first_throw_of_10th_frame_is_strike
    input = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 'X', 9, 1, 8, 0, 'X', 'X', 0, 0]
    expected = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], ['X'], [9, 1], [8, 0], ['X'], ['X', 0, 0]]
    assert_equal expected, to_scores_per_frame(input)
  end

  def test_frame_score_to_10th_frame
    input = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], ['X'], [9, 1], [8, 0], ['X'], [6, 3]]
    assert_equal 132, frame_score(input)
  end

  def test_frame_score_when_10th_frame_contains_strike
    input = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], ['X'], [9, 1], [8, 0], ['X'], ['X', 6, 4]]
    assert_equal 150, frame_score(input)
  end

  def test_frame_score_when_it_is_all_strike
    input = [['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], %w[X X X]]
    assert_equal 300, frame_score(input)
  end
end
