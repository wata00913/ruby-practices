# frozen_string_literal: true

require 'optparse'

# ファイルを表示する最大列数は3で固定
MAX_COL = 3

# 引数のパスからファイル名を配列として返す
# 配列の並び順はファイル名の昇順
def file_name_list_without_dot(path)
  Dir.glob(path).map { |name| File.basename(name) }
end

def file_name_list(path)
  Dir.glob(path, File::FNM_DOTMATCH).map { |name| File.basename(name) }
end

# 配列から行列に変換
# 列数は引数で指定し、行数は要素数 <= 列数×行数を満たす最大値
# 要素を順番に1列目から格納し、余った行列の要素はnilを補完
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
  fn_list = if ARGV.include?('-a')
              file_name_list(current_dir_patter)
            else
              file_name_list_without_dot(current_dir_patter)
            end
  display(fn_list)
end

ls if __FILE__ == $PROGRAM_NAME
