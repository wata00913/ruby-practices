# frozen_string_literal: true

require 'optparse'
require 'etc'

# ファイルを表示する最大列数は3で固定
MAX_COL = 3

PERMISSION = {
  fully_effective: { bit: 511 }.freeze,
  no_effect: { str: '-' }.freeze,
  readable: { bit: 4, str: 'r' }.freeze,
  writable: { bit: 2, str: 'w' }.freeze,
  executable: { bit: 1, str: 'x' }.freeze
}.freeze

# 引数のパスからファイル名を配列として返す
# 配列の並び順はファイル名の昇順
# @param [String] path ファイルリストの対象パス
# @param [Boolean] dot ファイルリストにドットファイルを含めるかどうかを指定
# @param [Boolean] reverse ファイルリストの並び順。trueの場合は名前の降順でfalseの場合は名前の昇順
# @return [Array] 引数のパスからファイル名を配列として返す
def make_file_name_list(path, dot: false, reverse: false)
  flags = dot ? File::FNM_DOTMATCH : 0
  file_name_list = Dir.glob(path, flags).map { |name| File.basename(name) }
  reverse ? file_name_list.reverse : file_name_list
end

# ファイルパスからlsコマンドで使用するファイル情報をハッシュとして返す
# @param [String] path ファイル情報の対象パス
# @return [Hash] ファイル情報をハッシュとして返す
def make_file_info(path)
  file_stat = File::Stat.new(path)
  file_info = {}
  file_info[:file_mode] = format_file_mode_to_ls_long(file_stat)
  file_info[:number_of_links] = file_stat.nlink
  file_info[:owner_name] = Etc.getpwuid(file_stat.uid).name
  file_info[:group_name] = Etc.getgrgid(file_stat.gid).name
  file_info[:bytes] = file_stat.size
  file_info[:month] = file_stat.mtime.strftime('%m').to_i
  file_info[:day] = file_stat.mtime.strftime('%d').to_i
  file_info[:hour_min] = file_stat.mtime.strftime('%H:%M')
  file_info[:filename] = File.basename(path)
  file_info[:blocks] = file_stat.blocks
  file_info
end

def calc_total_blocks(file_info_list)
  file_info_list.map { |file_info| file_info[:blocks] }.sum
end

# ファイルモードを-lオプションの形式にフォーマットする
# @param [File::Stat] ファイル情報格納クラス
# @return [String] -lオプションの形式にフォーマットしたファイルモードを返す
def format_file_mode_to_ls_long(file_stat)
  entry_type = format_entry_type_to_ls_long(file_stat)
  # ファイルモードはファイルタイプと特殊な権限にを左3桁の値を使用。
  # 全ユーザーのパーミッション値のみを取り出すために、ファイルモードと全ユーザーの有効パーミッションで論理積をとる
  three_permissions_bits = file_stat.mode & PERMISSION[:fully_effective][:bit]
  three_permissions = format_three_permissions_bits_to_ls_long(file_stat.mode & three_permissions_bits)
  "#{entry_type}#{three_permissions}"
end

# ファイルのタイプを-lオプションの形式にフォーマットする
# @param [File::Stat] ファイル情報格納クラス
# @return [String] -lオプションの形式にフォーマットしたファイルのタイプを返す
def format_entry_type_to_ls_long(file_stat)
  ftype_to_ls_long_format = {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'p',
    'link' => 'l',
    'socket' => 's'
  }
  ftype_to_ls_long_format[file_stat.ftype]
end

# ファイルの3ユーザー(オーナー、グループ、その他ユーザー)のパーミッションを-lオプションの形式にフォーマットする
# @param [Integer] 3ユーザーのパーミッションの整数値
# @return [String] -lオプションの形式にフォーマットしたファイルの3ユーザーのパーミッションを返す
def format_three_permissions_bits_to_ls_long(three_permissions_bits)
  formatted_permissions_list = []
  3.times do
    # 右から3bitのユーザpermissionを求める
    permission_bits = three_permissions_bits & 7
    formatted_permissions_list.unshift(
      format_permission_bits_to_ls_long(permission_bits)
    )

    # 1ユーザのpermissionを求めたら、右シフトさせて求めたユーザのビットは除去。
    # 次のユーザを対象とする
    three_permissions_bits = three_permissions_bits >> 3
  end
  formatted_permissions_list.join
end

# ファイルの1ユーザーのパーミッションを-lオプションの形式にフォーマットする
# @param [Integer] 1ユーザーのパーミッションの整数値
# @return [String] -lオプションの形式にフォーマットしたファイルの1ユーザーのパーミッションを返す
def format_permission_bits_to_ls_long(bits)
  fields = []
  fields << ((bits & PERMISSION[:readable][:bit]).zero? ? PERMISSION[:no_effect][:str] : PERMISSION[:readable][:str])
  fields << ((bits & PERMISSION[:writable][:bit]).zero? ? PERMISSION[:no_effect][:str] : PERMISSION[:writable][:str])
  fields << ((bits & PERMISSION[:executable][:bit]).zero? ? PERMISSION[:no_effect][:str] : PERMISSION[:executable][:str])
  fields.join
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

def display_file_name_line(file_name_list, width)
  puts file_name_list.inject('') { |line, file_nmae| line + file_nmae.ljust(width) }
end

def display_file_name_lines(file_name_list)
  # 標準出力がターミナル以外の場合、表示列数は1
  col = $stdout.tty? ? MAX_COL : 1
  file_name_mat = to_matrix(file_name_list, col)
  width = adjust_width_to_max_char_length(file_name_list)
  file_name_mat.each do |row|
    display_file_name_line(row.compact, width)
  end
end

def find_field_to_max_char_length(file_info_list)
  {
    file_mode: find_max_char_length(file_info_list, :file_mode),
    number_of_links: find_max_char_length(file_info_list, :number_of_links),
    owner_name: find_max_char_length(file_info_list, :owner_name),
    group_name: find_max_char_length(file_info_list, :group_name),
    bytes: find_max_char_length(file_info_list, :bytes),
    month: find_max_char_length(file_info_list, :month),
    day: find_max_char_length(file_info_list, :day),
    hour_min: find_max_char_length(file_info_list, :hour_min),
    filename: find_max_char_length(file_info_list, :filename)
  }
end

def find_max_char_length(file_info_list, field)
  file_info_list.map { |el| el[field].to_s.length }.max
end

def display_file_info_line(file_info, field_to_max_char_length)
  left_padding2 = 2
  left_padding1 = 1
  right_padding = 0
  inline_elements = [
    file_info[:file_mode],
    displayed_field_inline_element(file_info[:number_of_links].to_s, left_padding2, right_padding, 'rjust', field_to_max_char_length[:number_of_links]),
    displayed_field_inline_element(file_info[:owner_name], left_padding1, right_padding, 'rjust', field_to_max_char_length[:owner_name]),
    displayed_field_inline_element(file_info[:group_name], left_padding2, right_padding, 'rjust', field_to_max_char_length[:group_name]),
    displayed_field_inline_element(file_info[:bytes].to_s, left_padding2, right_padding, 'rjust', field_to_max_char_length[:bytes]),
    displayed_field_inline_element(file_info[:month].to_s, left_padding1, right_padding, 'rjust', field_to_max_char_length[:month]),
    displayed_field_inline_element(file_info[:day].to_s, left_padding1, right_padding, 'rjust', field_to_max_char_length[:day]),
    displayed_field_inline_element(file_info[:hour_min], left_padding1, right_padding, 'rjust', field_to_max_char_length[:hour_min]),
    displayed_field_inline_element(file_info[:filename], left_padding1, right_padding, 'ljust', field_to_max_char_length[:filename])
  ]
  puts inline_elements.join
end

def displayed_field_inline_element(text, left_padding, right_padding, align, width)
  content = case align
            when 'rjust'
              text.rjust(width)
            when 'ljust'
              text.ljust(width)
            end
  element = {
    left_padding: ' ' * left_padding,
    right_padding: ' ' * right_padding,
    content: content
  }
  "#{element[:left_padding]}#{element[:content]}#{element[:right_padding]}"
end

def display_file_info_lines(file_info_list, total_blocks)
  puts "total #{total_blocks}"
  field_to_max_char_length = find_field_to_max_char_length(file_info_list)
  file_info_list.each do |file_info|
    display_file_info_line(file_info, field_to_max_char_length)
  end
end

def ls
  ls_opts = { dot: false, reverse: false, long: false }
  OptionParser.new do |opts|
    opts.on('-a') { |_v| ls_opts[:dot] = true }
    opts.on('-l') { |_v| ls_opts[:long] = true }
    opts.on('-r') { |_v| ls_opts[:reverse] = true }
  end.parse!(ARGV)

  current_dir_pattern = '*'
  dot = ls_opts[:dot]
  reverse = ls_opts[:reverse]
  file_name_list = make_file_name_list(current_dir_pattern,
                                       dot: dot,
                                       reverse: reverse)
  if ls_opts[:long]
    file_info_list = file_name_list.map { |file_name| make_file_info(file_name) }
    total_blocks = calc_total_blocks(file_info_list)
    display_file_info_lines(file_info_list, total_blocks)
  else
    display_file_name_lines(file_name_list)
  end
end

ls if __FILE__ == $PROGRAM_NAME
