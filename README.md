# Xi 🗼

**Xi** (pronounced _Zai_) is a dynamic, stack-based concatenative language, written in [Oak](https://oaklang.org/) and using Oak types and semantics. I wrote Xi over the 2021 Labor Day weekend as a learning exercise to understand how stack languages work and why they're interesting. Xi is modeled mainly after [Factor](https://factorcode.org/), but this implementation is neither complete nor robust -- there's basically no error handling, for example, and Xi is not meant to be a faithful _re-implementation_ of Factor. It should run correct programs correctly, but will often fail on bad input.

```js
// Factorials to 10!
factorial : nat prod
10 ( ++ factorial print ) each-integer

// Fibonacci sequence to fib(25)
(fib) : dup 2 < ( drop swap drop ) ( ( swap over + ) dip -- (fib) ) if
fib : 1 1 rot (fib)
25 ( fib print ) each-integer
```

I've written more in-depth about my experiments with concatenative languages on my blog at [dotink.co](https://dotink.co/posts/xi/).

## Overview

Xi is dynamically typed, and operates on the same basic values as Oak except that all numbers are `float`s. Like other concatenative stack programming languages, each statement (line) in a Xi program is a sequence of _words_, where each word manipulates a single global _data stack_ in some way, usually by moving and changing a few values at the top of the stack. Literal values like numbers and strings simply move those values onto the stack.

For example, the word `+` pops the top two values off the stack, adds them together, and pushes the sum back on the stack.

```js
1 2 10
// stack: < 1 2 10 >
+
// stack: < 1 12 >
+
// stack: < 13 >
```

We can also write these words all next to each other, and have the same program.

```js
1 2 10 + +
// stack: < 13 >
```

This is where the name _concatenative_ language comes from -- putting words next to each other composes those functions together in a predictable way.

Sometimes, we need to shuffle some items in the stack around to work on the right values without doing any other computation. These are called _stack shuffling_ words. Xi provides 4 basic ones, from which more complex words can be defined:

```js
2 dup
// stack: < 2 2 > — duplicates the top value

1 2 3 ( + ) dip
// stack: < 3 3 > — runs a quotation (words inside `( ... )`) underneath the
// topmost value on the stack

1 2 drop
// stack: < 1 > — simply drops the topmost value on the stack

10 20 swap
// stack: < 20 10 > — swaps the top 2 values' places on the stack
```

As an example of basic composition, we can define `rot`, which rotates the top 3 items' places in the stack, like this.

```js
// define the word "rot"
rot : ( swap ) dip swap

1 2 3 rot
// stack: < 2 3 1 >
```

Xi's syntax is, like most concatenative languages, minimal. There are three kinds of primitive values: single-quoted strings, number (floating point) literals, and booleans `true` and `false`. Xi has lists and objects, delimited using `[ ... ]` and `{ ... }` respectively, though there isn't much of a vocabulary to work with objects. Finally, Xi has _quotations_, which are sequences of words that can be evaluated later, analogous to closures in other high-level languages. These types of values also represent the entirely of Xi's type system. There is no more sophisticated class system as in Factor.

Xi is a learning project, and thus not a great introduction to concatenative programming if you're new to it yourself. If you want to learn more about concatenative programming, you might want to check out these resources I found helpful as I learned about this space myself.

- [A panoramic tour of Factor](https://andreaferretti.github.io/factor-tutorial/), which is the most beginner-friendly treatment of Factor and concatenative programming I could find
- [A survey of stack shufflers](http://useless-factor.blogspot.com/2007/09/survey-of-stack-shufflers.html), which helped me get a better sense of how to use stack shuffling words, and how to "think in Factor", i.e. think about programming by composing words together
- [Google TechTalk on Factor by its creator Slava Pestov](https://www.youtube.com/watch?v=f_0QlhYlS8g), which gives a great high-level overview of what makes concatenative programming and Factor attractive
- [Bare metal x86 Forth](https://ph1lter.bitbucket.io/blog/2021-01-15-baremetal-x86-forth.html), an advanced and insightful deep dive into bootstrapping a concatenative programming language from assembly

### Xi repl

Xi has a basic repl, which I used to test and debug words before adding them to my programs. Simply running `./xi.oak` without any arguments will start the repl. Through the repl, you can run any Xi code. However, there are a few specific "debugging words" that are useful for inspecting program state when in the repl.

- `.` will pop the top value off of the stack and print it out.
- `.s` ("s" for "stack") will print out a representation of the entire data stack at that point in the program
- `.e` ("e" for "environment") will print out a dictionary of every word currently defined in scope and their definitions

## Examples

Though Xi is a pedagogical toy language and not exactly practical due to its brittleness and minimalism, there are a few sample programs I wrote to demonstrate how Xi programs work, and test my implementation. Besides these two, there is a small unit testing helper and test suite in `./test/unittests.xi`.

### Fizzbuzz

Here is some sample Xi code, the [FizzBuzz](https://en.wikipedia.org/wiki/Fizz_buzz) program. Though each statement must be in a single line in Xi, I've broken them up here into multiple lines for readability.

```js
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

should produce the correct output.

### Factorial

The sample [`./samples/factorial.xi`](samples/factorial.xi) computes factorials of every number from 1 to 10, inclusive, and prints it. This program is a great demonstration of how elegant and concise well-designed concatenative programs can be, if the right primitives are composed well. This program is just two short lines:

```js
factorial : nat prod
10 ( ++ factorial print ) each-integer
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
