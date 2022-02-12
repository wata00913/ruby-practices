# frozen_string_literal: true

require 'optparse'

def count_words(line)
  sep = /[\n\s]+/
  # 分割した要素に含まれる可能性がある空文字列は、除外してカウントする
  line.split(sep).count { |candidate| !candidate.empty? }
end

def count_lines(str)
  str.count("\n")
end

def count_chars(str)
  str.bytesize
end

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

def display_wc_line(counter, file_name = '',
                    visible_lines: true,
                    visible_words: true,
                    visible_chars: true)
  l_padding = 1
  width = 7
  elements = []
  # 左端列も空白が必要なので、rjustで列ごとの空白を作成
  elements.push(counter[:lines].to_s.rjust(l_padding + width)) if visible_lines
  elements.push(counter[:words].to_s.rjust(l_padding + width)) if visible_words
  elements.push(counter[:chars].to_s.rjust(l_padding + width)) if visible_chars
  elements.push(file_name.rjust(l_padding + file_name.size)) unless file_name.empty?

  elements.join
end

def collect_file(pattern)
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
  wc_opts.transform_values! { |_v| true } unless wc_opts.values.all?

  file_name_list = ARGV.map { |pattern| collect_file(pattern) }.flatten

  # ファイル指定がない場合は、標準入力のカウントを行う
  files_counter = if file_name_list.empty?
                    [{ name: '', counter: create_counter($stdin) }]
                  else
                    file_name_list.map do |file_name|
                      File.open(file_name) do |f|
                        { name: file_name, counter: create_counter(f) }
                      end
                    end
                  end

  if files_counter.size > 1
    counters = files_counter.map { |fc| fc[:counter] }
    files_counter.push({ name: 'total', counter: total_count(counters) })
  end

  files_counter.each do |fc|
    puts display_wc_line(fc[:counter],
                         fc[:name],
                         visible_lines: wc_opts[:lines],
                         visible_words: wc_opts[:words],
                         visible_chars: wc_opts[:chars])
  end
end

wc if __FILE__ == $PROGRAM_NAME
