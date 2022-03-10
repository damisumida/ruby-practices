1.upto(20) { |i|
  if i % 3 == 0
    if i % 5 == 0
      puts 'FizzBuzz'
    else
      puts 'Fizz'
    end
  elseif i % 5 == 0
    puts 'Buzz'
  else
    puts i
  end
}
