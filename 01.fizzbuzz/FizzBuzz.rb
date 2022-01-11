i=1
20.times do
  if (i%3)==0 
    if (i%5)==0 
        puts "FizzBuzz"
    else
        puts "Fizz"
    end
  else
    if (i%5)==0
      puts "Buzz"
    else
      puts i
    end
  end
  i=i+1
end
