# frozen_string_literal: true

module Ls
  class LongFormatter
    def initialize(options)
      @options = options
      @ls_files = Ls::Files.new(**@options.slice(:paths, :dot))
    end

    def to_lines
      max_char_sizes = %i[nlink owner group bytes].map do |attr|
        # 数値のattrがあるため文字列に変換をしてサイズを
        ["max_#{attr}".to_sym, @ls_files.find_max(attr).to_s.size]
      end.to_h

      [
        "total #{@ls_files.total_blocks}",
        *info_lines(**max_char_sizes)
      ]
    end

    private

    def info_lines(max_char_sizes)
      lines = []
      @ls_files.each_order_by(:name, desc: @options[:reverse]) do |info|
        lines << info_line(info, **max_char_sizes)
      end
      lines
    end

    def info_line(info, max_nlink:, max_owner:, max_group:, max_bytes:)
      [
        info.mode,
        "  #{info.nlink.to_s.rjust(max_nlink)}",
        " #{info.owner.rjust(max_owner)}",
        "  #{info.group.rjust(max_group)}",
        "  #{info.bytes.to_s.rjust(max_bytes)}",
        " #{info.mtime.strftime('%m %d %H:%M')}",
        " #{info.name}"
      ].join
    end
  end
end
