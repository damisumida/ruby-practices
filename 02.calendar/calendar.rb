require 'optparse'
require 'date'

#オプションの取得
options = ARGV.getopts('y:', 'm:')
year = options["y"].to_i #年
month = options["m"].to_i #月

#年月が指定されなかった場合、現在の年月を設定
if year == 0
    year = Date.today.year
end
if month == 0
    month = Date.today.mon
end

#カレンダー1行目
if month.to_i < 10
    puts "       " + month.to_s + "月 " + year.to_s + "年" #年月表示(月が1桁)
else
    puts "      " + month.to_s + "月 " + year.to_s + "年" #年月表示（月が2桁）
end

#カレンダー2行目
puts "日 月 火 水 木 金 土" #曜日表示

#日付の取得
first_day = Date.new(year, month, 1).strftime('%a') #月初の曜日
last_day = Date.new(year, month, -1).day #月末日

#月初の曜日から1週目の日数取得
first_week_days = 0
case first_day
when "Sun" then
    first_week_days = 7
when "Mon" then
    first_week_days = 6
when "Tue" then
    first_week_days = 5
when "Wed"
    first_week_days = 4
when "Thu"
    first_week_days = 3
when "Fri"
    first_week_days = 2
when "Sat"
    first_week_days = 1
end

#1週目
#空行表示
if first_week_days != 7
    (1..7-first_week_days).each do |day|
        print "   "
    end
end
#日付表示
(1..first_week_days).each do |day|
    print " "
    print day
    if day != first_week_days

        print " "
    end
end
print "\n" 

#2週目以降
i = 1 #繰り返した回数
#1週目の日数＋1～末日まで繰り返す
(first_week_days+1..last_day).each do |day|
    #1桁の日の場合はスペースを入れる
    if day < 10
        print " "
    end

    print day

    if i%7 == 0 
        print "\n" #7回目で改行
    else
        print " " #改行しない場合はスペースを入れる
    end
    i += 1
end
