MAX_COL = 3

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

def column_width(str_list)
  multiple = 8
  max_str_length = str_list.map(&:length).max
  ((max_str_length / multiple) + 1) * multiple
end

def print_line(files, width)
  line = files.inject('') { |line, file| line += file.ljust(width) }
  puts line
end

def print(files)
  files_list = to_matrix(files.sort, MAX_COL, true)
  col_width = column_width(files)
  files_list.each do |fs|
    print_line(fs, col_width)
  end
end

def ls
  fs = files_without_dot('.')
  print(fs)
end

ls if __FILE__ == $PROGRAM_NAME
