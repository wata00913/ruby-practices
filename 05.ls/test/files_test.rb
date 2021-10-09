# frozen_string_literal: true

require 'minitest/autorun'
require 'set'
require_relative '../ls'

class FilesTest < Minitest::Test
  def test_ls_files_excluding_dot_files
    path = './test-data/**'
    file_name_list = file_name_list_without_dot(path)
    expected = Set.new(%w[fuga.txt hoge hoge.txt])
    assert_equal expected, Set.new(file_name_list)
  end

  class LsFilesTest < Minitest::Test
    def test_ls_files_including_dot_files
      path = './test-data/**'
      fn_list = file_name_list(path)
      expected = Set.new(%w[. .. .hoge.rc fuga.txt hoge hoge.txt])
      assert_equal expected, Set.new(fn_list)
    end
  end

  def test_convert_to_1_by_3_matrix
    elements = %w[fuga.txt hoge.txt hoge]
    expected = [%w[fuga.txt hoge.txt hoge]]
    assert_equal expected, to_matrix(elements, 3)
  end

  def test_convert_to_2_by_3_matrix
    elements = %w[fuga2.txt hoge.txt hoge fuga fuga.txt]
    expected = [['fuga2.txt', 'hoge', 'fuga.txt'],
                ['hoge.txt', 'fuga', nil]]
    assert_equal expected, to_matrix(elements, 3)
  end

  def test_width_when_max_string_length_of_elements_is_less_than_eight
    arr = %w[hoge 1234567]
    assert_equal 8, adjust_width_to_max_char_length(arr)
  end

  def test_width_when_max_string_length_of_elements_is_multiple_of_eight
    arr = %w[hogehoge 02]
    assert_equal 16, adjust_width_to_max_char_length(arr)
  end

  def test_width_when_max_string_length_of_elements_is_longer_than_eight
    arr = %w[hogehogeh 02]
    assert_equal 16, adjust_width_to_max_char_length(arr)
  end
end
