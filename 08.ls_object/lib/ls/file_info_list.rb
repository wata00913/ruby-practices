# frozen_string_literal: true

require 'forwardable'

module Ls
  class FileInfoList
    extend Forwardable
    attr_reader :infos

    def_delegator :@infos, :map, 'map'

    def initialize(paths: [], dot: false)
      target_files = if paths.empty?
                       files_in(dot: dot)
                     else
                       dirs, files = paths.partition { |p| File.directory?(p) }
                       files += dirs.map { |d| files_in(d, dot: dot) }.flatten! unless dirs.empty?
                       files
                     end
      @infos = target_files.map { |f| Ls::FileInfo.new(f) }
    end

    def total_blocks
      @infos.sum(&:blocks)
    end

    def extract(attr)
      @infos.map(&attr)
    end

    def find_max(attr)
      @infos.map(&attr).max
    end

    def sort_by!(attr, desc: false)
      @infos.sort_by!(&attr)
      @infos.reverse! if desc
    end

    private

    def files_in(dir = nil, dot:)
      pattern = dir.nil? ? '*' : File.join(dir, '*')
      flags = dot ? File::FNM_DOTMATCH : 0
      Dir.glob(pattern, flags)
    end
  end
end
