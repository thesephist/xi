// Fibonacci sequence

// a b n -> fib(n): if n < 2, return b; else, recurse on b, a+b
(fib) : dup 2 < ( drop swap drop ) ( ( swap over + ) dip -- (fib) ) if
// n -> fib(n)
fib : 1 1 rot (fib)

// main
25 ( fib print ) each-integer

