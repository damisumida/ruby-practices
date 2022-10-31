# !/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'readline'

TEXT_LENGTH = 4

def main
  option = parse_argv
  file_info_list = build_file_info_list(option[:file_name])
  file_info_list.push(calc_total(file_info_list)) if file_info_list.size != 1
  show_file_info_list(file_info_list, option)
end

def parse_argv
  option = Hash.new(false)
  OptionParser.new do |opt|
    opt.on('-l') { |v| option[:line_num] = v }
    opt.on('-w') { |v| option[:word_num] = v }
    opt.on('-c') { |v| option[:file_size] = v }
    opt.parse!(ARGV)
  end
  option[:file_name] = ARGV
  option
end

def build_file_info_list(filenames)
  file_info_list = []
  if filenames.size.zero?
    content_value = $stdin.readlines.join
    file_info_list.push(build_file_info(content_value, nil))
  else
    filenames.each do |file_name|
      content_value = File.read("#{Dir.pwd}/#{file_name}")
      file_info_list.push(build_file_info(content_value, file_name))
    end
  end
  file_info_list
end

def build_file_info(content_value, file_name)
  {
    line_num: content_value.count("\n"),
    word_num: content_value.split(/\s+/).size,
    file_size: content_value.size,
    file_name: file_name
  }
end

def calc_total(file_info_list)
  file_info = {}
  file_info[:line_num] = file_info_list.sum { |info| info[:line_num] }
  file_info[:word_num] = file_info_list.sum { |info| info[:word_num] }
  file_info[:file_size] = file_info_list.sum { |info| info[:file_size] }
  file_info[:file_name] = 'total'
  file_info
end

def show_file_info_list(file_info_list, option)
  all_unchecked = option.values_at(:line_num, :word_num, :file_size).none?
  word_size = calc_wordsize(file_info_list)
  file_info_list.each do |info|
    info.each do |key, value|
      show_item(key, value, word_size) if all_unchecked || option[key]
    end
    puts
  end
end

def calc_wordsize(file_info_list)
  word_size = [TEXT_LENGTH]
  %w[line_num word_num file_size].each do |key|
    word_size.push(file_info_list.map { |info| info[key].to_s.size })
  end
  word_size.flatten.max
end

def show_item(key, value, word_size)
  if key == :file_name
    print value.to_s
  else
    print value.to_s.rjust(word_size)
    print ' '
  end
end

main
