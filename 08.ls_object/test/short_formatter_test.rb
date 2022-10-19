# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls'

class ShortFormatterTest < MiniTest::Test
  def test_to_lines
    options = {
      paths: ['./data'],
      dot: false,
      col: 3
    }
    formatter = Ls::ShortFormatter.new(options)
    expected = <<~TEXT.chomp
      fuga.txt        hoge2.txt       hoge6.txt
      hoge.txt        hoge3.txt       hoge7.txt
      hoge1.txt       hoge4.txt
      hoge10.txt      hoge5.txt
    TEXT
    assert_equal expected, formatter.to_lines.join("\n")
  end

  def test_to_lines_with_dot_and_reverse_options
    options = {
      paths: ['./data'],
      dot: true,
      reverse: true,
      col: 3
    }
    formatter = Ls::ShortFormatter.new(options)
    expected = <<~TEXT.chomp
      hoge7.txt       hoge3.txt       hoge.txt
      hoge6.txt       hoge2.txt       fuga.txt
      hoge5.txt       hoge10.txt      ..
      hoge4.txt       hoge1.txt       .
    TEXT
    assert_equal expected, formatter.to_lines.join("\n")
  end
end
