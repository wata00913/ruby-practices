# frozen_string_literal: true

require 'minitest/autorun'
require 'set'
require_relative '../ls'

class FilesTest < Minitest::Test
  class FileStatTest < Minitest::Test
    def setup
      @base_dir = './test-data'
      @basename1 = 'fuga.txt'
      @basename2 = '.'
      @path1 = File.join(@base_dir, @basename1)
      @path2 = File.join(@base_dir, @basename2)

      @file_info1 = { file_mode: '-rw-r--r--',
                      number_of_links: 1,
                      owner_name: 'sakamotoryuuji',
                      group_name: 'staff',
                      bytes: 0,
                      month: 9,
                      day: 23,
                      hour_min: '20:20',
                      filename: 'fuga.txt' }

      @file_info2 = { file_mode: 'drwxr-xr-x',
                      number_of_links: 6,
                      owner_name: 'sakamotoryuuji',
                      group_name: 'staff',
                      bytes: 192,
                      month: 9,
                      day: 23,
                      hour_min: '20:20',
                      filename: '.' }
    end

    def test_make_file_info1
      file_info = { file_mode: '-rw-r--r--',
                    number_of_links: 1,
                    owner_name: 'sakamotoryuuji',
                    group_name: 'staff',
                    bytes: 0,
                    month: 9,
                    day: 23,
                    hour_min: '20:20',
                    filename: 'fuga.txt',
                    blocks: 0 }
      assert_equal file_info, make_file_info(@path1)
    end

    def test_make_file_info2
      file_info = { file_mode: 'drwxr-xr-x',
                    number_of_links: 6,
                    owner_name: 'sakamotoryuuji',
                    group_name: 'staff',
                    bytes: 192,
                    month: 9,
                    day: 23,
                    hour_min: '20:20',
                    filename: '.',
                    blocks: 0 }
      assert_equal file_info, make_file_info(@path2)
    end

    def test_return_rw‐r‐‐r‐‐_string_when_octal_value_is_754
      assert_equal 'rwxr-xr--', format_three_permissions_bits_to_ls_long('754'.to_i(8))
    end

    def test_return_rw‐r‐‐r‐‐_string_when_octal_value_is_421
      assert_equal 'r---w---x', format_three_permissions_bits_to_ls_long('421'.to_i(8))
    end
  end

  class LsFilesTest < Minitest::Test
    def setup
      @path = './test-data/**'
    end

    def test_ls_files_excluding_dot_files_order_by_file_name
      fn_list = make_file_name_list(@path)
      expected = %w[fuga.txt hoge hoge.txt]
      assert_equal expected, fn_list
    end

    def test_ls_files_including_dot_files_order_by_file_name
      fn_list = make_file_name_list(@path, dot: true)
      expected = %w[. .. .hoge.rc fuga.txt hoge hoge.txt]
      assert_equal expected, fn_list
    end

    def test_ls_files_excluding_dot_files_order_by_file_name_desc
      fn_list = make_file_name_list(@path, reverse: true)
      expected = %w[hoge.txt hoge fuga.txt]
      assert_equal expected, fn_list
    end

    def test_ls_files_including_dot_files_order_by_file_name_desc
      fn_list = make_file_name_list(@path, dot: true, reverse: true)
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
