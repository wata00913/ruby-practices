# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/stub_any_instance'
require 'time'
require 'set'
require_relative '../lib/ls'

class FileInfoTest < MiniTest::Test
  def setup
    @dir = './data'
    @text_file_name = 'fuga.txt'
    @dot_file_name = '.'
  end

  def test_file_name
    path = File.join(@dir, @text_file_name)
    file_info = Ls::FileInfo.new(path)
    assert_equal 'fuga.txt', file_info.name
  end

  def test_to_h
    path = File.join(@dir, @dot_file_name)
    file_info = Ls::FileInfo.new(path)

    expected = {
      mode: 'drwxr-xr-x',
      nlink: 12,
      owner: 'sakamotoryuuji',
      group: 'staff',
      bytes: 384,
      mtime: Time.new(2021, 11, 1, 11, 50),
      name: '.',
      blocks: 0
    }
    File::Stat.stub_any_instance(:mtime, Time.new(2021, 11, 1, 11, 50)) do
      assert_equal expected, file_info.to_h
    end
  end
end
