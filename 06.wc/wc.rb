def count_words(line)
  sep = /[\n\s]+/
  line.split(sep).size
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
