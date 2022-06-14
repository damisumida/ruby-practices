# !/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'readline'

def main
  options = ARGV.getopts('l')
  filename_list = ARGV
  word_size = 0
  file_info = if filename_list.size.zero?
                word_size = 7
                file_status = readlines.join
                [build_file_info(options, file_status, nil)]
              else
                build_file_info_list(options, filename_list)
              end
  show_file_info(file_info, word_size)
end

def build_file_info_list(options, filename_list)
  file_info = []
  filename_list.each do |file_name|
    file_status = File.read("#{Dir.pwd}/#{file_name}")
    file_info.push(build_file_info(options, file_status, file_name))
  end
  file_info.push(calc_total(file_info)) unless file_info.size == 1
  file_info
end

def build_file_info(options, file_status, file_name)
  if options['l']
    build_l_data(file_status, file_name)
  else
    build_data(file_status, file_name)
  end
end

def build_l_data(file_status, file_name)
  {
    line_num: file_status.count("\n"),
    file_name: file_name
  }
end

def build_data(file_status, file_name)
  {
    line_num: file_status.count("\n"),
    word_num: file_status.split(/\s+/).size,
    file_size: file_status.size,
    file_name: file_name
  }
end

def calc_total(file_info)
  line_num = file_info.sum { |info| info[:line_num] }
  word_num = file_info.sum { |info| info[:word_num] } unless file_info[0][:word_num].nil?
  file_size = file_info.sum { |info| info[:file_size] } unless file_info[0][:file_size].nil?
  if file_info[0][:word_num].nil?
    {
      line_num: line_num,
      file_name: 'total'
    }
  else
    {
      line_num: line_num,
      word_num: word_num,
      file_size: file_size,
      file_name: 'total'
    }
  end
end

def show_file_info(file_info, word_size)
  word_size = build_word_size(file_info) if word_size.zero?
  file_info.each do |info|
    info.each do |key_value|
      show_item(info, key_value, word_size)
    end
    puts
  end
end

def build_word_size(file_info)
  max_word_size = 0
  file_info.each do |info|
    info.each { |key_value| max_word_size = info[key_value[0]].to_s.size if info[key_value[0]].to_s.size >= max_word_size && key_value[0] != :file_name }
  end
  max_word_size
end

def show_item(info, key_value, word_size)
  if key_value[0] == :file_name
    print info[key_value[0]]
  else
    print info[key_value[0]].to_s.rjust(word_size)
  end
  print ' '
end

main
