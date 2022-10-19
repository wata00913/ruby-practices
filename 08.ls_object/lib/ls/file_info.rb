# frozen_string_literal: true

require 'etc'

module Ls
  class FileInfo
    ENTRY_FORMAT = {
      'file' => '-',
      'directory' => 'd',
      'characterSpecial' => 'c',
      'blockSpecial' => 'b',
      'fifo' => 'p',
      'link' => 'l',
      'socket' => 's'
    }.freeze

    PERMISSION_FORMAT = {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }.freeze

    def initialize(path)
      @path = path
      @stat = File::Stat.new(path)
    end

    def name
      File.basename(@path)
    end

    def mode
      str_mode = @stat.mode.to_s(8)
      to_symbolic_mode(entry: @stat.ftype, permissions: str_mode[-3..])
    end

    def nlink
      @stat.nlink
    end

    def owner
      Etc.getpwuid(@stat.uid).name
    end

    def group
      Etc.getgrgid(@stat.gid).name
    end

    def bytes
      @stat.size
    end

    def mtime
      @stat.mtime
    end

    def blocks
      @stat.blocks
    end

    def to_h
      {
        mode: mode,
        nlink: nlink,
        owner: owner,
        group: group,
        bytes: bytes,
        mtime: mtime,
        name: name,
        blocks: blocks
      }
    end

    private

    def to_symbolic_mode(entry:, permissions:)
      "#{ENTRY_FORMAT[entry]}#{permissions.gsub(/./, PERMISSION_FORMAT)}"
    end
  end
end
