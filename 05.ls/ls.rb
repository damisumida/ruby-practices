# !/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMN = 3

def main
  options = ARGV.getopts('a')
  filename_list = create_file_list(options)
  return if filename_list.empty?

  filename_table = create_filename_table(filename_list)
  show_filename_table(filename_list, filename_table)
end

def create_file_list(options)
  arg = ['*']
  arg.push('.*') if options['a']
  filename_list = Dir.glob(arg)
  filename_list.flatten.sort
end

def create_filename_table(filename_list)
  line_num = (filename_list.size / COLUMN.to_f).ceil
  filename_table = filename_list.each_slice(line_num).map do |column|
    column << nil while column.size < line_num # 配列の要素数をそろえる
    column
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
