# frozen_string_literal: true

require 'minitest/autorun'
require 'set'
require_relative '../ls'

class FilesTest < Minitest::Test
  class FileStatTest < Minitest::Test
    def test_return_rw‐r‐‐r‐‐_string_when_octal_value_is_754
      assert_equal 'rwxr-xr--', to_s_three_permissions('754'.to_i(8))
    end

    def test_return_rw‐r‐‐r‐‐_string_when_octal_value_is_421
      assert_equal 'r---w---x', to_s_three_permissions('421'.to_i(8))
    end
  end

  class LsFilesTest < Minitest::Test
    def setup
      @path = './test-data/**'
    end

    def test_ls_files_excluding_dot_files_order_by_file_name
      fn_list = get_file_name_list(@path)
      expected = %w[fuga.txt hoge hoge.txt]
      assert_equal expected, fn_list
    end

    def test_ls_files_including_dot_files_order_by_file_name
      fn_list = get_file_name_list(@path, dot: true)
      expected = %w[. .. .hoge.rc fuga.txt hoge hoge.txt]
      assert_equal expected, fn_list
    end

    def test_ls_files_excluding_dot_files_order_by_file_name_desc
      fn_list = get_file_name_list(@path, reverse: true)
      expected = %w[hoge.txt hoge fuga.txt]
      assert_equal expected, fn_list
    end

    def test_ls_files_including_dot_files_order_by_file_name_desc
      fn_list = get_file_name_list(@path, dot: true, reverse: true)
      expected = %w[hoge.txt hoge fuga.txt .hoge.rc .. .]
      assert_equal expected, fn_list
    end
  end

  class ToMatrixTest < Minitest::Test
    class ConvertElementsToNByMMatrix < Minitest::Test
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
    end
  end

  class AdjustWidthToMaxCharLength < MiniTest::Test
    class MinMultipleOf8ThatExceedsMaxLengthOfCharList < MiniTest::Test
      def test_return_8_when_max_length_of_char_list_is7
        arr = %w[hoge 1234567]
        assert_equal 8, adjust_width_to_max_char_length(arr)
      end

      def test_return_16_when_max_length_of_char_list_is8
        arr = %w[hogehoge 02]
        assert_equal 16, adjust_width_to_max_char_length(arr)
      end

      def test_return_16_when_max_length_of_char_list_is9
        arr = %w[hogehogeh 02]
        assert_equal 16, adjust_width_to_max_char_length(arr)
      end
    end
  end
end
