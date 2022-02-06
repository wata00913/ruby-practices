def count_words(line)
  sep = /[\n\s]+/
  line.split(sep).size
end

def count_lines(str)
  str.count("\n")
end
