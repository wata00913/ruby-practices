# frozen_string_literal: true

require 'forwardable'

module Ls
  class FileInfoList
    extend Forwardable

    def_delegator :@infos, :map, 'map'

    class << self
      def create_from(paths: [], dot: false)
        target_files = if paths.empty?
                         files_in(dot: dot)
                       else
                         dirs, files = paths.partition { |p| File.directory?(p) }
                         files += dirs.map { |d| files_in(d, dot: dot) }.flatten! unless dirs.empty?
                         files
                       end
        file_info_arr = target_files.map { |f| Ls::FileInfo.new(f) }
        new(file_info_arr)
      end

      private

      def files_in(dir = nil, dot:)
        pattern = dir.nil? ? '*' : File.join(dir, '*')
        flags = dot ? File::FNM_DOTMATCH : 0
        Dir.glob(pattern, flags)
      end
    end

    def initialize(file_info_arr)
      @infos = file_info_arr
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
  end
end
