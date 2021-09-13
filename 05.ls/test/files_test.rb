# frozen_string_literal: true

require 'minitest/autorun'
require 'set'
require_relative '../ls'

class FilesTest < Minitest::Test
  def test_ls_files_excluding_dot_files
    path = './test-data/'
    fs = files_without_dot(path)
    expected = Set.new(%w[fuga.txt hoge hoge.txt])
    assert_equal expected, Set.new(fs)
  end

  def test_convert_to_array_of_arrays
    fs = %w[fuga.txt hoge.txt hoge]
    expected = [%w[fuga.txt hoge.txt hoge]]
    assert_equal expected, to_array_of_arrays(fs, 3)
  end

  def test_convert_to_array_of_two_arrays
    fs = %w[fuga2.txt hoge.txt hoge fuga fuga.txt]
    expected = [['fuga2.txt', 'hoge', 'fuga.txt'],
                ['hoge.txt', 'fuga']]
    assert_equal expected, to_array_of_arrays(fs, 3)
  end

  def test_column_width_when_max_string_length_of_elements_is_less_than_eight
    arr = %w[hoge 1234567]
    assert_equal 8, column_width(arr)
  end

  def test_column_width_when_max_string_length_of_elements_is_multiple_of_eight
    arr = %w[hogehoge 02]
    assert_equal 16, column_width(arr)
  end

  def test_column_width_when_max_string_length_of_elements_is_longer_than_eight
    arr = %w[hogehogeh 02]
    assert_equal 16, column_width(arr)
  end
end
