# !/usr/bin/env ruby
# frozen_string_literal: true

COLUMN = 3

def main
  filename_list = Dir.glob('*').sort
  return if filename_list.size.zero?

  filename_table = create_filename_table(filename_list)
  show_filename_table(filename_list, filename_table)
end

def create_filename_table(filename_list)
  filename_table = []
  COLUMN.times do |count|
    filename_table.push(create_column(filename_list, count))
  end
  filename_table.transpose
end

def create_column(filename_list, count)
  line = []
  line_num = (filename_list.size / COLUMN.to_f).ceil
  line_num.times do |i|
    line.push(filename_list[count * line_num + i])
  end
  line
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
