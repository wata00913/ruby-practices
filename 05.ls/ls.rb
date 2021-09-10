MAX_COL = 3
WIDTH = 16

def files_without_dot(path)
  files = Dir.children(path)
  files.reject { |f| f.match?('^\.') }
end

def to_matrix(elements, max_col, vertical = false)
  size = elements.size
  max_row = if (size % max_col).zero?
              size / max_col
            else
              (size / max_col) + 1
            end
  matrix = Array.new(max_row) { [] }

  elements.each_with_index do |element, idx|
    row = vertical ? matrix[idx % max_row] : matrix[idx / max_col]
    row << element
  end
  matrix
end

def print_line(files)
  line = files.inject('') { |line, file| line += file.ljust(WIDTH) }
end

def print(files)
  files_list = to_matrix(files.sort, MAX_COL)
  files_list.each do |files|
    print_line(files)
  end
end

def ls
  fs = files_without_dot('.')
  print(fs)
end

ls if __FILE__ == $PROGRAM_NAME
