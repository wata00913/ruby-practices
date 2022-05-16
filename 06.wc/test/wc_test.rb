# frozen_string_literal: true

require 'stringio'
require 'minitest/autorun'
require_relative '../wc'

class WCTest < Minitest::Test
  class WordsCounterTest < Minitest::Test
    def test_count_words_separated_by_whitespace
      line = "hoge fuga\nhoge\tあ"
      assert_equal 4, count_words(line)
    end

    def test_count_words_separated_by_whitespace2
      line = " hoge fuga\nhoge\tあ"
      assert_equal 4, count_words(line)
    end

    def test_not_count_words_when_only_separators
      line = "\n\t    "
      assert_equal 0, count_words(line)
    end

    def test_count_words_separated_by_whitespace_even_if_consecutive_whitespace
      line = "hoge fuga\n\nhoge\tあ"
      assert_equal 4, count_words(line)
    end
  end

  class LinesCounterTest < Minitest::Test
    def test_count_newline
      str = "hoge\nf\n"
      assert_equal 2, count_lines(str)
    end

    def test_not_count_empty
      str = ''
      assert_equal 0, count_lines(str)
    end
  end

  class CharctersCounterTest < Minitest::Test
    def test_count_str_by_byte_length
      str = "あいう😄\n"
      assert_equal 14, count_chars(str)
    end

    def test_count_str_by_byte_length2
      str = "hoge\n"
      assert_equal 5, count_chars(str)
    end
  end

  def test_create_counter_from_file
    input_path = './input.txt'
    expected = { lines: 3, words: 4, chars: 26 }
    File.open(input_path) do |f|
      assert_equal expected, create_counter(f)
    end
  end

  def test_create_counter_from_stdin
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
    def test_displayed_wc_line_with_default_options_and_in_file
      expected = '       3       4      26 input.txt'
      counter = { lines: 3, words: 4, chars: 26 }
      file_name = 'input.txt'
      assert_equal expected, displayed_wc_line(counter, file_name)
    end

    def test_displayed_wc_line_with_one_option_and_in_file
      expected = '       3 input.txt'
      counter = { lines: 3, words: 4, chars: 26 }
      file_name = 'input.txt'
      assert_equal expected, displayed_wc_line(counter, file_name,
                                               visible_words: false,
                                               visible_chars: false)
    end

    def test_displayed_wc_line_with_default_options_and_in_stdin
      expected = '       3       4      26'
      counter = { lines: 3, words: 4, chars: 26 }
      file_name = ''
      assert_equal expected, displayed_wc_line(counter, file_name)
    end
  end
end
