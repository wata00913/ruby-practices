# frozen_string_literal: true

module Ls
  class LongFormatter
    def initialize(options)
      @options = options
      @file_info_list = Ls::FileInfoList.create_from(**@options.slice(:paths, :dot))
    end

    def to_lines
      max_char_sizes = %i[nlink owner group bytes].map do |attr|
        # 数値のattrがあるため文字列に変換をしてサイズを
        ["max_#{attr}".to_sym, @file_info_list.find_max(attr).to_s.size]
      end.to_h

      @file_info_list.sort_by!(:name, desc: @options[:reverse])
      [
        "total #{@file_info_list.total_blocks}",
        *lines(@file_info_list, **max_char_sizes)
      ]
    end

    private

    def lines(file_info_list, max_char_sizes)
      file_info_list.map { |finfo| line(finfo, **max_char_sizes) }
    end

    def line(file_info, max_nlink:, max_owner:, max_group:, max_bytes:)
      [
        file_info.mode,
        "  #{file_info.nlink.to_s.rjust(max_nlink)}",
        " #{file_info.owner.rjust(max_owner)}",
        "  #{file_info.group.rjust(max_group)}",
        "  #{file_info.bytes.to_s.rjust(max_bytes)}",
        " #{file_info.mtime.strftime('%m %d %H:%M')}",
        " #{file_info.name}"
      ].join
    end
  end
end
