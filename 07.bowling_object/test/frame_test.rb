# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../frame'

class FrameTest < MiniTest::Test
  NORMAL_SHOTS = [6, 3].freeze
  SPARE_SHOTS = [6, 4].freeze
  STRIKE_SHOTS = [10].freeze

  class ScoreTest < MiniTest::Test
    def test_normal_score
      f = Frame.new(NORMAL_SHOTS)
      assert_equal 9, f.score
    end

    def test_strike_score
      f = Frame.new(STRIKE_SHOTS)
      assert_equal 10, f.score
    end
  end

  class SpareTest < MiniTest::Test
    def test_spare
      f = Frame.new(SPARE_SHOTS)
      assert f.spare?
    end

    def test_not_spare_when_strike
      f = Frame.new(STRIKE_SHOTS)
      assert_equal false, f.spare?
    end
  end

  class StrikeTest < MiniTest::Test
    def test_strike
      f = Frame.new(STRIKE_SHOTS)
      assert f.strike?
    end

    def test_not_strike_when_spare
      f = Frame.new(SPARE_SHOTS)
      assert_equal false, f.strike?
    end
  end
end
