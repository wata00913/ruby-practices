require 'minitest/autorun'
require_relative '../wc'

class WCTest < Minitest::Test
  class WordsCounterTest < Minitest::Test
    def test_制御文字で区切られた文字数をカウント
      line = "hoge fuga\nhoge\tあ"
      assert_equal 4, count_words(line)
    end

    def test_文字列が制御文字のみの場合に文字数0でカウント
      line = "\n\t    "
      assert_equal 0, count_words(line)
    end

    def test_連続した制御文字は１つの制御文字として文字数をカウント
      line = "hoge  fuga\n\nhoge"
      assert_equal 3, count_words(line)
    end
  end

  class LinesCounterTest < Minitest::Test
    def test_文字列で改行を区切り文字としてカウント
      str = "hoge\nf\n"
      assert_equal 2, count_lines(str)
    end

    def test_空文字列は0行でカウント
      str = ''
      assert_equal 0, count_lines(str)
    end
  end
end
