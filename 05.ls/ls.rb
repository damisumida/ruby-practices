# !/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

COLUMN = 3

def main
  options = ARGV.getopts('a', 'r', 'l')
  filename_list = create_file_list(options)
  return if filename_list.empty?

  filename_list = filename_list.reverse if options['r']
  if options['l']
    file_attributes = create_file_attributes(filename_list)
    show_total(file_attributes)
    show_file_attributes(file_attributes)
  else
    filename_table = connect_filename(filename_list)
    show_filename_table(filename_list, filename_table)
  end
end

def create_file_list(options)
  filename_list = Dir.glob('*', if options['a']
                                  File::FNM_DOTMATCH
                                else
                                  0
                                end)
  filename_list.flatten.sort
end

def create_file_attributes(filename_list)
  file_attribute = []
  filename_list.each do |file_name|
    file_attribute.push(create_file_attribute(file_name))
  end
  file_attribute
end

def create_file_attribute(file_name)
  file_status = File.stat("#{Dir.pwd}/#{file_name}")
  {
    file_kind: kinds(file_status),
    attribute: attribute(file_status),
    herdlink_num: file_status.nlink.to_s,
    group_name: Etc.getpwuid(file_status.gid).name,
    user_name: Etc.getgrgid(file_status.uid).name,
    file_size: file_status.size.to_s,
    timestamp: timestamp(file_status),
    file_name: file_name,
    block: file_status.blocks
  }
end

def kinds(file_status)
  file_status = file_status.ftype
  status = {
    '-' => 'file',
    'd' => 'directory',
    'c' => 'characterSpecial',
    'b' => 'blockSpecial',
    'l' => 'link'
  }
  status.key(file_status)
end

def attribute(file_status)
  file_status = file_status.mode.to_s(8)
  attributes = {
    'rwx' => '7',
    'rw-' => '6',
    'r-x' => '5',
    'r--' => '4',
    '-wx' => '3',
    '-w-' => '2',
    '--x' => '1',
    '---' => '0'
  }
  attributes.key(file_status.slice(-3)) + attributes.key(file_status.slice(-2)) + attributes.key(file_status.slice(-1))
end

def timestamp(file_status)
  file_timestamp = file_status.mtime
  file_timestamp.strftime '%b %d %H:%M'
end

def show_total(file_attributes)
  total = 0
  file_attributes.each do |file_attribute|
    total += file_attribute[:block]
  end
  total /= 2
  puts "total #{total}"
end

def show_file_attributes(file_attributes)
  word_size = create_word_size(file_attributes)
  file_attributes.each do |file_attribute|
    file_attribute.each do |key_value|
      show_item(file_attribute, word_size, key_value)
    end
    puts
  end
end

def create_word_size(file_attributes)
  max_word_num = {
    file_kind: 0,
    attribute: 0,
    herdlink_num: 0,
    group_name: 0,
    user_name: 0,
    file_size: 0,
    timestamp: 0,
    file_name: 0,
    block: 0
  }
  file_attributes.each do |file_attribute|
    file_attribute.each do |key_value|
      max_word_num[key_value[0]] = file_attribute[key_value[0]].size if max_word_num[key_value[0]] < file_attribute[key_value[0]].size
    end
  end
  max_word_num
end

def show_item(file_attribute, word_size, key_value)
  return if key_value[0] == :block

  if key_value[0] == :herdlink_num || key_value[0] == :file_size
    print file_attribute[key_value[0]].to_s.rjust(word_size[key_value[0]])
  else
    print file_attribute[key_value[0]].to_s.ljust(word_size[key_value[0]])
  end
  return if key_value[0] == :file_kind

  print ' '
end

def connect_filename(filename_list)
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
