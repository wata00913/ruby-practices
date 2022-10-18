# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls'

class FilesTest < MiniTest::Test
  def setup
    @dir = './data'
  end

  def test_file_names
    files = Ls::Files.new(paths: ['./data'])
    expected = ['fuga.txt', 'hoge.txt', 'hoge1.txt', 'hoge10.txt', 'hoge2.txt', 'hoge3.txt', 'hoge4.txt', 'hoge5.txt', 'hoge6.txt', 'hoge7.txt']
    assert_equal expected, files.names
  end

  def test_file_names_with_dot
    files = Ls::Files.new(paths: ['./data'], dot: true)
    expected = ['.', '..', 'fuga.txt', 'hoge.txt', 'hoge1.txt', 'hoge10.txt', 'hoge2.txt', 'hoge3.txt', 'hoge4.txt', 'hoge5.txt', 'hoge6.txt', 'hoge7.txt']
    assert_equal expected, files.names
  end

  def test_file_names2
    files = Ls::Files.new(paths: ['./data/fuga.txt'])
    assert_equal ['fuga.txt'], files.names
  end
end
