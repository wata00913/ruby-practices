# frozen_string_literal: true

MAX_COL = 3

def file_name_list_without_dot(path)
  file_name_list = Dir.children(path)
  file_name_list.reject { |f| f.match?('^\.') }
end

def to_matrix(elements, col_size)
  size = elements.size
  max_row = if (size % col_size).zero?
              size / col_size
            else
              (size / col_size) + 1
            end
  matrix = Array.new(max_row) { Array.new(col_size) { nil } }

  elements.each_with_index do |element, idx|
    row = matrix[idx % max_row]
    row[idx / max_row] = element
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

def print(file_name_list)
  col = $stdout.tty? ? MAX_COL : 1
  file_name_mat = to_matrix(file_name_list.sort, col)
  col_width = column_width(file_name_list)
  file_name_mat.each do |row|
    print_line(row.reject(&:nil?), col_width)
  end
end

def ls
  file_name_list = file_name_list_without_dot('.')
  print(file_name_list)
end

ls if __FILE__ == $PROGRAM_NAME
