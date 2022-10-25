# frozen_string_literal: true

module Ls
  class FileInfoList
    attr_reader :infos

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

    def names(reverse: false)
      ns = @infos.map(&:name)
      reverse ? ns.reverse : ns
    end

    def total_blocks
      @infos.sum(&:blocks)
    end

    def find_max(attr)
      @infos.map(&attr).max
    end

    def each_order_by(attr, desc: false, &block)
      infos = @infos.sort_by(&attr)
      infos = infos.reverse if desc
      infos.each(&block)
    end

    private

    def files_in(dir = nil, dot:)
      pattern = dir.nil? ? '*' : File.join(dir, '*')
      flags = dot ? File::FNM_DOTMATCH : 0
      Dir.glob(pattern, flags)
    end
  end
end
