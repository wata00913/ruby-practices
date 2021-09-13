# frozen_string_literal: true

MAX_COL = 3

def files_without_dot(path)
  files = Dir.children(path)
  files.reject { |f| f.match?('^\.') }
end

def to_array_of_arrays(elements, max_inner_array_size)
  size = elements.size
  max_row = if (size % max_inner_array_size).zero?
              size / max_inner_array_size
            else
              (size / max_inner_array_size) + 1
            end
  matrix = Array.new(max_row) { [] }

  elements.each_with_index do |element, idx|
    row = matrix[idx % max_row]
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
  puts files.inject('') { |line, file| line + file.ljust(width) }
end

def print(files)
  col = $stdout.tty? ? MAX_COL : 1
  files_list = to_array_of_arrays(files.sort, col)
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
