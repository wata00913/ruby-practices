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

  def test_行列に分割
    fs = %w[fuga.txt hoge.txt hoge]
    expected = [%w[fuga.txt hoge hoge.txt]]
    expected = [%w[fuga.txt hoge.txt hoge]]
    assert_equal expected, to_matrix(fs, 3)
  end

  def test_複数行を跨ぐ行列に分割
    fs = %w[fuga2.txt hoge.txt hoge fuga fuga.txt]
    expected = [['fuga2.txt', 'hoge.txt', 'hoge'],
                ['fuga', 'fuga.txt']]
    assert_equal expected, to_matrix(fs, 3)
  end

  def test_複数行を跨ぐ行列に分割かつ行列を反転
    fs = %w[fuga2.txt hoge.txt hoge fuga fuga.txt]
    expected = [['fuga2.txt', 'hoge', 'fuga.txt'],
                ['hoge.txt', 'fuga']]
    assert_equal expected, to_matrix(fs, 3, true)
  end
end
