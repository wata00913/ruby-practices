require 'minitest/autorun'
require './bowling'

class BowlingTest < Minitest::Test
  def test_to_frames
    input = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 'X', 9, 1, 8, 0, 'X', 6, 4, 5]
    expected = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], ['X'], [9, 1], [8, 0], ['X'], [6, 4, 5]]
    assert_equal expected, to_frames(input)
  end

  def test_10フレーム目で3投連続ストライクの場合
    input = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 'X', 9, 1, 8, 0, 'X', 'X', 'X', 'X']
    expected = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], ['X'], [9, 1], [8, 0], ['X'], %w[X X X]]
    assert_equal expected, to_frames(input)
  end

  def test_10フレームで1投目がストライクの場合
    input = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 'X', 9, 1, 8, 0, 'X', 'X', 0, 0]
    expected = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], ['X'], [9, 1], [8, 0], ['X'], ['X', 0, 0]]
    assert_equal expected, to_frames(input)
  end

  def test_1フレーム目のスコア
    input = [[1, 2]]
    assert_equal 3, score(input, 1)
  end

  def test_2フレーム目のスコア
    input = [[1, 2], [3, 5]]
    assert_equal 11, score(input, 2)
  end

  def test_スペアを含んだスコア
    input = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3]]
    assert_equal 38, score(input, 4)
  end

  def test_スペアの次の投球がストライク文字列になる場合のスコア
    input = [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], ['X'], [9, 1]]
    assert_equal 78, score(input, 6)
  end
end
