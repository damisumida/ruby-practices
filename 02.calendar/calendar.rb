require 'optparse'
require 'date'

def saturday?(date)
  if date.wday == 6
    print "\n"
  else
    print ' '
  end
end

options = ARGV.getopts("y:", "m:")
year = options['y'].to_i
month = options['m'].to_i
year = Date.today.year if year.zero?
month = Date.today.month if month.zero?

# カレンダー1行目
puts "#{month}月 #{year}".center(20)

# カレンダー2行目
puts '日 月 火 水 木 金 土'

# 日付の取得
first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)

# 初日
print (first_day.day.to_s).rjust(first_day.wday * 3 + 2)
saturday?(first_day)
# 2日目以降
(2..last_day.day).each.with_index do |day, idx|
  print (day.to_s).rjust(2)
  saturday?(first_day + idx + 1)
end
print "\n"
