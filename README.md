# Xi 🗼

**Xi** is a dynamic, stack-based concatenative language, written in [Oak](https://oaklang.org/) and using Oak types and semantics. I wrote Xi over the 2021 Labor Day weekend as a learing exercise to understand how stack languages work and why they're interesting. Xi is modeled largely after [Factor](https://factorcode.org/), but this implementation is neither complete nor robust -- there's basically no error handling, for example. It should run correct programs correctly, but otherwise, try at your own risk.

I've written more in-depth about my experiments with concatenative languages on my blog at [dotink.co](https://dotink.co/posts/xi/).

## Overview

// TODO

## Examples

Though Xi is a padagogial toy language and not exactly practical due to its brittleness and minimalism, there are a few sample programs I wrote to demonstrate how Xi programs work, and test my implementation. Besides these two, there is a small unit testing helper and test suite in `./test/unittests.xi`.

### Fizzbuzz

Here is some sample Xi code, the [FizzBuzz](https://en.wikipedia.org/wiki/Fizz_buzz) program. Though each statement must be in a single line in Xi, I've broken them up here into multiple lines for readability.

```factor
// FizzBuzz in Xi

// n -> _
fizzbuzz : dup 15 divisible? (
    'FizzBuzz' print drop
) (
    dup 3 divisible?
    (
        'Fizz' print drop
    ) (
        dup 5 divisible?
        ( 'Buzz' print drop ) ( print ) if
    )
    if
) if

// main
100 ( ++ fizzbuzz ) each-integer
```

Here, the word `fizzbuzz` consumes a number at the top of the data stack and prints either 'Fizz', 'Buzz', 'FizzBuzz', or the number to output. The main program `100 ( ++ fizzbuzz ) each-integer` performs the quotation (`++ fizzbuzz`) for each integer counting up from 0 to 100, exclusive. Running this program with

```sh
./xi.oak ./samples/fizzbuzz.xi
```

Should produce the correct output.

### Factorial

The sample ['./samples/factorial.xi'](samples/factorial.xi) computes factorials of every number from 1 to 10, inclusive, and prints it. This program is a great demonstration of how elegant and concise well-designed concatenative programs can be, if the right primitives are composed well. This program is just two short lines:

```factor
factorial : nat prod
10 nat ( factorial ) map ( print ) each
```

First, we define the word `factorial` that takes a number, generates a list of numbers counting up from 1 to that number (`nat`), and takes their total product (`prod`). Then we loop through every number from 1 to 10, and compute the factorial and print it. This generates the correct output

```
1
2
6
24
120
720
5040
40320
362880
3.6288e+06
```

## Development

Xi is a project written in the [Oak programming language](https://oaklang.org/). All of the core language and "kernel" is defined in a single Oak program, `./xi.oak`.

A small unit test suite is defined in `./test/unittests.xi`. To run it, simply run

```sh
./xi.oak ./test/unittests.xi
```

