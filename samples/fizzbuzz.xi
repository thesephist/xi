// FizzBuzz

// n -> _
fizzbuzz : dup 15 divisible? ( 'FizzBuzz' print drop ) ( dup 3 divisible? ( 'Fizz' print drop ) ( dup 5 divisible? ( 'Buzz' print drop ) ( print ) if ) if ) if

// main
100 ( ++ fizzbuzz ) each-integer

