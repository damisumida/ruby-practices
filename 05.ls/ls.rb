# !/usr/bin/env ruby
# frozen_string_literal: true

COLUMN = 3

def main
  filename_list = Dir.glob('*').sort
  return if filename_list.empty?

  filename_table = create_filename_table(filename_list)
  show_filename_table(filename_list, filename_table)
end

def create_filename_table(filename_list)
  filename_table = []
  line_num = (filename_list.size / COLUMN.to_f).ceil
  filename_list.each_slice(line_num) do |column|
    column << nil while column.size < line_num # 配列の要素数をそろえる
    filename_table.push(column)
  end
  filename_table.transpose
end

def show_filename_table(filename_list, filename_table)
  item_long = filename_list.max_by(&:length).length + 1
  filename_table.each do |filename_column|
    filename_column.each do |item|
      print item.ljust(item_long) unless item.nil?
    end
    puts
  end
end

main
