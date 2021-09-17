# frozen_string_literal: true

MAX_COL = 3

def file_name_list_without_dot(path)
  file_name_list = Dir.children(path)
  file_name_list.reject { |file_name| file_name.match?('^\.') }
end

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

def adjust_width_to_max_char_length(str_list)
  multiple = 8
  max_char_length = str_list.map(&:length).max
  ((max_char_length / multiple) + 1) * multiple
end

def print_line(file_name_list, width)
  puts file_name_list.inject('') { |line, file_nmae| line + file_nmae.ljust(width) }
end

def print(file_name_list)
  col = $stdout.tty? ? MAX_COL : 1
  file_name_mat = to_matrix(file_name_list.sort, col)
  width = adjust_width_to_max_char_length(file_name_list)
  file_name_mat.each do |row|
    print_line(row.reject(&:nil?), width)
  end
end

def ls
  file_name_list = file_name_list_without_dot('.')
  print(file_name_list)
end

ls if __FILE__ == $PROGRAM_NAME
