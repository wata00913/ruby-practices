# frozen_string_literal: true

require 'optparse'

# 文字列から単語数をカウントする
# 単語の区切り文字は空白文字と改行文字
# @param [String] str 文字列
# @return [Integer] 単語数
def count_words(str)
  sep = /[\n\s]+/
  # 分割した要素に含まれうる空文字列は、除外してカウントする
  str.split(sep).count { |candidate| !candidate.empty? }
end

# 文字列から行数をカウントする
# @param [String] str 文字列
# @return [Integer] 行数
def count_lines(str)
  str.count("\n")
end

# 文字列の文字数をカウントする
# ここでの文字数は文字列のバイト長とする
# @param [String] str 文字列
# @return [Integer] 文字数
def count_chars(str)
  str.bytesize
end

# ファイルを読み込んで、ファイルのCounterを作成
# Counterは行数、単語数、文字数で構成されるHash
# @param [IO] io IO、またはIOのeach_lineメソッドを継承したインスタンス変数(Fileクラスなど)
# @return [Hash] ファイルの行数、単語数、文字数を構成するHash
def create_counter(io)
  total_lines = 0
  total_words = 0
  total_chars = 0
  io.each_line do |line|
    total_lines += count_lines(line)
    total_words += count_words(line)
    total_chars += count_chars(line)
  end
  { lines: total_lines, words: total_words, chars: total_chars }
end

# ファイルごとのCounterを作成する
# ファイル指定がない場合は、標準入力のCounterを作成する
# @param [Array] file_name_list ファイル名を要素とする配列
# @return [Array] ファイルごとのCounterを要素とする配列
# 具体的な要素は、ファイル名とそのファイルのCounterを構成するHash
def create_file_counters(file_name_list)
  if file_name_list.empty?
    [{ name: '', counter: create_counter($stdin) }]
  else
    file_name_list.map do |file_name|
      File.open(file_name) { |f| { name: file_name, counter: create_counter(f) } }
    end
  end
end

# 複数のCounterの行数、単語数、文字数ごとに合計したCounterを返す
# @param [Array] str 文字列
# @return [Hash] ファイルの行数、単語数、文字数を構成するHash
def total_count(counters)
  total_lines = 0
  total_words = 0
  total_chars = 0
  counters.each do |counter|
    total_lines += counter[:lines]
    total_words += counter[:words]
    total_chars += counter[:chars]
  end
  { lines: total_lines, words: total_words, chars: total_chars }
end

def displayed_wc_line(counter, file_name = '',
                      visible_lines: true,
                      visible_words: true,
                      visible_chars: true)
  l_padding = 1
  width = 7
  elements = []
  # joinで空白は作成しない
  # 左端列も空白が必要なので、rjustで列ごとの空白を作成
  elements.push(counter[:lines].to_s.rjust(l_padding + width)) if visible_lines
  elements.push(counter[:words].to_s.rjust(l_padding + width)) if visible_words
  elements.push(counter[:chars].to_s.rjust(l_padding + width)) if visible_chars
  elements.push(file_name.rjust(l_padding + file_name.size)) unless file_name.empty?

  elements.join
end

def display_wc_lines(file_counters, wc_opts)
  file_counters.each do |fc|
    puts displayed_wc_line(fc[:counter],
                           fc[:name],
                           visible_lines: wc_opts[:lines],
                           visible_words: wc_opts[:words],
                           visible_chars: wc_opts[:chars])
  end
end

def collect_file_name_list(pattern)
  Dir.glob(pattern).filter { |name| File.file?(name) }
end

def wc
  wc_opts = { lines: false, words: false, chars: false }
  OptionParser.new do |opts|
    opts.on('-l') { |_v| wc_opts[:lines] = true }
    opts.on('-w') { |_v| wc_opts[:words] = true }
    opts.on('-c') { |_v| wc_opts[:chars] = true }
  end.parse!(ARGV)

  # オプション指定がない場合はデフォルトオプションを使用。
  wc_opts.transform_values! { |_v| true } unless wc_opts.values.any?

  file_name_list = ARGV.map { |pattern| collect_file_name_list(pattern) }.flatten

  file_counters = create_file_counters(file_name_list)

  if file_counters.size > 1
    counters = file_counters.map { |fc| fc[:counter] }
    file_counters.push({ name: 'total', counter: total_count(counters) })
  end

  display_wc_lines(file_counters, wc_opts)
end

wc if __FILE__ == $PROGRAM_NAME
