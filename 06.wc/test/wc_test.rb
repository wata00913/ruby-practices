require 'stringio'
require 'minitest/autorun'
require_relative '../wc'

class WCTest < Minitest::Test
  class WordsCounterTest < Minitest::Test
    def test_単語の間に区切り文字がある場合に区切られた単語数をカウントする
      line = "hoge fuga\nhoge\tあ"
      assert_equal 4, count_words(line)
    end

    def test_先頭に区切り文字があっても単語の間に区切り文字がある場合に区切られた単語数をカウントする
      line = " hoge fuga\nhoge\tあ"
      assert_equal 4, count_words(line)
    end

    def test_区切り文字のみある場合に単語数をカウントしない
      line = "\n\t    "
      assert_equal 0, count_words(line)
    end

    def test_単語の間に連続した区切り文字がある場合に連續した区切り文字は1つの区切り文字として扱い、区切られた文字数をカウントする
      line = "hoge fuga\n\nhoge\tあ"
      assert_equal 4, count_words(line)
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

  class CharctersCounterTest < Minitest::Test
    def test_文字列をバイト長でカウント
      str = "あいう😄\n"
      assert_equal 14, count_chars(str)
    end

    def test_文字列をバイト長でカウント2
      str = "hoge\n"
      assert_equal 5, count_chars(str)
    end
  end

  def test_create_counter_by_file
    input_path = './input.txt'
    expected = { lines: 3, words: 4, chars: 26 }
    File.open(input_path) do |f|
      assert_equal expected, create_counter(f)
    end
  end

  def test_create_counter_by_stdin
    expected = { lines: 1, words: 1, chars: 9 }
    StringIO.open("😄😄\n") do |io|
      assert_equal expected, create_counter(io)
    end
  end

  def test_total_counter
    expected = { lines: 89, words: 227, chars: 2496 }
    counters = [
      { lines: 3, words: 4, chars: 26 },
      { lines: 86, words: 223, chars: 2470 }
    ]
    assert_equal expected, total_count(counters)
  end

  class ViewTest < Minitest::Test
    def test_wc_line
      expected = '       3       4      26 input.txt'
      counter = { lines: 3, words: 4, chars: 26 }
      file_name = 'input.txt'
      assert_equal expected, display_wc_line(counter, file_name)
    end

    def test_wc_line2
      expected = '       3 input.txt'
      counter = { lines: 3, words: 4, chars: 26 }
      file_name = 'input.txt'
      assert_equal expected, display_wc_line(counter, file_name,
                                             visible_words: false,
                                             visible_chars: false)
    end

    def test_wc_line3
      expected = '       3       4      26'
      counter = { lines: 3, words: 4, chars: 26 }
      file_name = ''
      assert_equal expected, display_wc_line(counter, file_name)
    end
  end
end
