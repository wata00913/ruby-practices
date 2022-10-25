# frozen_string_literal: true

module Ls
  class ShortFormatter
    def initialize(options)
      @options = options

      @file_info_list = Ls::FileInfoList.create_from(**@options.slice(:paths, :dot))
    end

    def to_lines
      @file_info_list.sort_by!(:name, desc: @options[:reverse])
      names = @file_info_list.extract(:name)

      width = adjust_width_to_max_name_length(names)
      names_in_transposed = to_transposed_matrix_format(names, @options[:col])

      lines(names_in_transposed, width)
    end

    private

    def lines(names_in_transposed, width)
      names_in_transposed.map do |names|
        # nilは不要のため、nilを削除後に行を生成
        names.compact.inject('') { |line, name| line + name.ljust(width) }.rstrip
      end
    end

    def to_transposed_matrix_format(names, col_size)
      row_size = (names.size.to_f / col_size).ceil
      # transposeできるように足りない分だけnilを追加
      names += [nil] * (row_size * col_size - names.size)
      names.each_slice(row_size).to_a.transpose
    end

    # ファイル名の最大長+1が8の倍数を満たすように横幅を計算
    # 倍数値は開発環境を元に設定
    def adjust_width_to_max_name_length(names)
      multiple = 8
      max_name_length = names.map(&:length).max
      ((max_name_length / multiple) + 1) * multiple
    end
  end
end
