# !/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l')
  filename_list = ARGV
  file_info = create_file_info(options, filename_list)
  show_file_info(file_info)
end

def create_file_info(options, filename_list)
  file_info = []
  filename_list.each do |file_name|
    if options['l']
      file_info.push(count_line_num(file_name))
    else
      file_info.push(build_data(file_name))
    end
  end
  file_info.push(calc_total_info(file_info)) unless options['l']
  file_info
end

def build_data(file_name)
  file_status = File.read("#{Dir.pwd}/#{file_name}")
  {
    line_num: file_status.count("\n"),
    word_num: file_status.length,
    file_size: file_status.size,
    file_name: file_name
  }
end

def count_line_num(file_name)
  file_status = File.read("#{Dir.pwd}/#{file_name}")
  {
    line_num: file_status.count("\n"),
    file_name: file_name
  }
end

def calc_total_info(file_info)
  line_num = file_info.sum { |info| info[:line_num] }
  word_num = file_info.sum { |info| info[:word_num] }
  file_size = file_info.sum { |info| info[:file_size] }
  {
    line_num: line_num,
    word_num: word_num,
    file_size: file_size
  }
end

def show_file_info(file_info)
  word_size = create_word_size(file_info)
  file_info.each do |info|
    info.each do |key_value|
      print info[key_value[0]].to_s.rjust(word_size[key_value[0]] + 1)
    end
    puts
  end
end

def create_word_size(file_info)
  max_word_num = {
    line_num: 0,
    word_num: 0,
    file_size: 0,
    file_name: 0
  }
  file_info.each do |info|
    info.each do |key_value|
      max_word_num[key_value[0]] = info[key_value[0]].to_s.size if max_word_num[key_value[0]] < info[key_value[0]].to_s.size
    end
  end
  max_word_num
end

main
