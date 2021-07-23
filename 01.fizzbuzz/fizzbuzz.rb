def fizz_buzz
  (1..20).each do |x|
    if least_common_multiple_of_3_and_5?(x)
      puts "FizzBuzz"
    elsif multiple_of_3?(x)
      puts "Fizz"
    elsif multiple_of_5?(x)
      puts "Buzz"
    else
      puts x
    end
  end
end

def least_common_multiple_of_3_and_5?(x)
  multiple_of_3?(x) && multiple_of_5?(x)
end

def multiple_of_3?(x)
  x % 3 == 0
end

def multiple_of_5?(x)
  x % 5 == 0
end

fizz_buzz
