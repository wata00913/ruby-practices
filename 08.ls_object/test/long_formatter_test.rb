# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls'

class LongFormatterTest < MiniTest::Test
  def test_to_lines
    options = { paths: ['./data'] }
    formatter = Ls::LongFormatter.new(options)
    expected = <<~TEXT.chomp
      total 8
      -rw-r--r--  1 sakamotoryuuji  staff  637 10 19 10:06 fuga.txt
      -rw-r--r--  1 sakamotoryuuji  staff    0 10 18 10:56 hoge.txt
      -rw-r--r--  1 sakamotoryuuji  staff    0 10 18 16:44 hoge1.txt
      -rw-r--r--  1 sakamotoryuuji  staff    0 10 18 16:44 hoge10.txt
      -rw-r--r--  1 sakamotoryuuji  staff    0 10 18 16:44 hoge2.txt
      -rw-r--r--  1 sakamotoryuuji  staff    0 10 18 16:44 hoge3.txt
      -rw-r--r--  1 sakamotoryuuji  staff    0 10 18 16:44 hoge4.txt
      -rw-r--r--  1 sakamotoryuuji  staff    0 10 18 16:44 hoge5.txt
      -rw-r--r--  1 sakamotoryuuji  staff    0 10 18 16:44 hoge6.txt
      -rw-r--r--  1 sakamotoryuuji  staff    0 10 18 16:44 hoge7.txt
    TEXT
    assert_equal expected, formatter.to_lines.join("\n")
  end

  def test_to_lines_with_dot_and_reverse_options
    options = { paths: ['./data'], dot: true, reverse: true }
    formatter = Ls::LongFormatter.new(options)
    expected = <<~TEXT.chomp
      total 8
      -rw-r--r--   1 sakamotoryuuji  staff    0 10 18 16:44 hoge7.txt
      -rw-r--r--   1 sakamotoryuuji  staff    0 10 18 16:44 hoge6.txt
      -rw-r--r--   1 sakamotoryuuji  staff    0 10 18 16:44 hoge5.txt
      -rw-r--r--   1 sakamotoryuuji  staff    0 10 18 16:44 hoge4.txt
      -rw-r--r--   1 sakamotoryuuji  staff    0 10 18 16:44 hoge3.txt
      -rw-r--r--   1 sakamotoryuuji  staff    0 10 18 16:44 hoge2.txt
      -rw-r--r--   1 sakamotoryuuji  staff    0 10 18 16:44 hoge10.txt
      -rw-r--r--   1 sakamotoryuuji  staff    0 10 18 16:44 hoge1.txt
      -rw-r--r--   1 sakamotoryuuji  staff    0 10 18 10:56 hoge.txt
      -rw-r--r--   1 sakamotoryuuji  staff  637 10 19 10:06 fuga.txt
      drwxr-xr-x   7 sakamotoryuuji  staff  224 10 19 14:20 ..
      drwxr-xr-x  12 sakamotoryuuji  staff  384 10 19 10:06 .
    TEXT
    actual = formatter.to_lines.join("\n")
    assert_equal expected, actual
  end
end
