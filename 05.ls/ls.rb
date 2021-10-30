# frozen_string_literal: true

require 'optparse'

# ファイルを表示する最大列数は3で固定
MAX_COL = 3

# 引数のパスからファイル名を配列として返す
# 配列の並び順はファイル名の昇順
# @param [String] path ファイルリストの対象パス
# @param [Boolean] dot ファイルリストにドットファイルを含めるかどうかを指定
# @param [Boolean] reverse ファイルリストの並び順。trueの場合は名前の降順でfalseの場合は名前の昇順
# @return [Array] 引数のパスからファイル名を配列として返す
def get_file_name_list(path, dot: false, reverse: false)
  flags = dot ? File::FNM_DOTMATCH : 0
  file_name_list = Dir.glob(path, flags).map { |name| File.basename(name) }
  reverse ? file_name_list.reverse : file_name_list
end

# 配列から行列に変換
# 列数は引数で指定し、行数は要素数 <= 列数×行数を満たす最大値
# 要素を順番に1列目から格納し、余った行列の要素はnilを補完
# @param [Array] elements 行列に変換する対象の配列
# @param [Integer] col_size 行列の列数
# @return [Array] 配列を二次元配列に変換したものを返す
def to_matrix(elements, col_size)
  row_size = if (elements.size % col_size).zero?
               elements.size / col_size
             else
               (elements.size / col_size) + 1
             end
  matrix = Array.new(row_size) { Array.new(col_size) { nil } }

  elements.each_with_index do |element, idx|
    row = matrix[idx % row_size]
    row[idx / row_size] = element
  end
  matrix
end

# 文字配列の最大長に応じて横幅を求める
# 最大長+1が8の倍数を満たすように横幅を計算
# @param [Array] str_list 文字列を要素とする配列
# @return [Integer] 横幅を返す
def adjust_width_to_max_char_length(str_list)
  multiple = 8
  max_char_length = str_list.map(&:length).max
  ((max_char_length / multiple) + 1) * multiple
end

def display_line(file_name_list, width)
  puts file_name_list.inject('') { |line, file_nmae| line + file_nmae.ljust(width) }
end

def display(file_name_list)
  # 標準出力がターミナル以外の場合、表示列数は1
  col = $stdout.tty? ? MAX_COL : 1
  file_name_mat = to_matrix(file_name_list, col)
  width = adjust_width_to_max_char_length(file_name_list)
  file_name_mat.each do |row|
    display_line(row.compact, width)
  end
end

def ls
  current_dir_patter = '*'
  dot = ARGV.include?('-a')
  reverse = ARGV.include?('-r')
  file_name_list = get_file_name_list(current_dir_patter,
                                      dot: dot,
                                      reverse: reverse)
  display(file_name_list)
end

ls if __FILE__ == $PROGRAM_NAME
