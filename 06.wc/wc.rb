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
