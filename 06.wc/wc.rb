# !/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'readline'

def main
  filename_list = build_filename_list
  file_info_list = build_file_info_list(filename_list)
  file_info_list.push(calc_total(file_info_list)) if file_info_list.size != 1
  show_file_info_list(file_info_list, filename_list)
end

def build_filename_list
  opts = OptionParser.new do |opt|
    opt.on('-l', '-w', '-c')
  end
  opts.parse(ARGV)
end

def build_file_info_list(filename_list)
  file_info_list = []
  if filename_list.size.zero?
    input_value = $stdin.readlines.join
    file_info_list.push(build_file_info(input_value, nil))
  else
    filename_list.map do |file_name|
      file_status = File.read("#{Dir.pwd}/#{file_name}")
      file_info_list.push(build_file_info(file_status, file_name))
    end
  end
  file_info_list
end

def build_file_info(file_status, file_name)
  option = search_option
  file_info = {}
  file_info['line_num'] = file_status.count("\n") if option[:l] || option_all_unchecked?(option)
  file_info['word_num'] = file_status.split(/\s+/).size if option[:w] || option_all_unchecked?(option)
  file_info['file_size'] = file_status.size if option[:c] || option_all_unchecked?(option)
  file_info['file_name'] = file_name
  file_info
end

def search_option
  option = Hash.new(false)
  OptionParser.new do |opt|
    opt.on('-l') { |v| option[:l] = v }
    opt.on('-w') { |v| option[:w] = v }
    opt.on('-c') { |v| option[:c] = v }
    opt.parse(ARGV)
  end
  option
end

def option_all_unchecked?(option)
  if option[:l] || option[:w] || option[:c]
    false
  else
    true
  end
end

def calc_total(file_info_list)
  option = search_option
  file_info = {}
  file_info['line_num'] =  sum_file_info(file_info_list, 'line_num') if option[:l] || option_all_unchecked?(option)
  file_info['word_num'] =  sum_file_info(file_info_list, 'word_num') if option[:w] || option_all_unchecked?(option)
  file_info['file_size'] =  sum_file_info(file_info_list, 'file_size') if option[:c] || option_all_unchecked?(option)
  file_info['file_name'] =  'total'
  file_info
end

def sum_file_info(file_info_list, key_name)
  file_info_list.sum { |info| info[key_name] }
end

def show_file_info_list(file_info_list, filename_list)
  word_size = build_word_size(file_info_list, filename_list)
  file_info_list.each do |info|
    info.each do |key_value|
      key = key_value[0]
      value = info[key_value[0]]
      show_item(key, value, word_size)
    end
    puts
  end
end

def build_word_size(file_info_list, filename_list)
  word_size = []
  word_size.push(default_word_size(filename_list))
  word_size.push(file_info_list.map { |info| info['line_num'].to_s.size }.max)
  word_size.push(file_info_list.map { |info| info['word_num'].to_s.size }.max)
  word_size.push(file_info_list.map { |info| info['file_size'].to_s.size }.max)
  word_size.max
end

def default_word_size(filename_list)
  if filename_list.size >= 1
    4
  elsif filename_list.size.zero?
    7
  end
end

def show_item(key, value, word_size)
  if key == 'file_name'
    print value.to_s.ljust(1)
  else
    print value.to_s.rjust(word_size)
  end
  print ' '
end

main
