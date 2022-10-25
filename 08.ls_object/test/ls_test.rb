# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls'

class LsTest < MiniTest::Test
  def setup
    @default_options = { dot: false, reverse: false, long: false, col: 3, paths: ['./data'] }
  end

  def test_short_format_without_options
    expected = <<~TEXT.chomp
      fuga.txt        hoge2.txt       hoge6.txt
      hoge.txt        hoge3.txt       hoge7.txt
      hoge1.txt       hoge4.txt
      hoge10.txt      hoge5.txt
    TEXT
    assert_equal expected, ls(@default_options)
  end

  def test_short_format_with_all_options
    opts = @default_options.clone
    opts[:dot] = true
    opts[:reverse] = true

    expected = <<~TEXT.chomp
      hoge7.txt       hoge3.txt       hoge.txt
      hoge6.txt       hoge2.txt       fuga.txt
      hoge5.txt       hoge10.txt      ..
      hoge4.txt       hoge1.txt       .
    TEXT
    assert_equal expected, ls(opts)
  end

  def test_long_format_without_options
    opts = @default_options.clone
    opts[:long] = true

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
    assert_equal expected, ls(opts)
  end

  def test_long_format_with_all_options
    opts = @default_options.clone
    opts[:long] = true
    opts[:dot] = true
    opts[:reverse] = true

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
      drwxr-xr-x   4 sakamotoryuuji  staff  128 10 26 08:08 ..
      drwxr-xr-x  12 sakamotoryuuji  staff  384 10 19 10:06 .
    TEXT
    assert_equal expected, ls(opts)
  end
end
