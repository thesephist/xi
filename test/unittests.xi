// Basic unit test library and tests for Xi

// asserts that the top two things on the stack are equal
// a b -> _
assert! : rot pick pick = ( '  ' swap + ': ok' + print ) ( '! ' swap + ': failed, results below:' + print .s ) if drop2

// asserts whether results of top two quotations on stack are the same to N
// depths in stack
eq! : ( call ) dip call assert!
eq2! : ( call list2 ) dip call list2 assert!
eq3! : ( call list3 ) dip call list3 assert!
eq4! : ( call list4 ) dip call list4 assert!
eq5! : ( call list5 ) dip call list5 assert!

'Xi unit tests:' print

// primitive ops
'Simple binary operator' ( 1 2 + ) ( 3 ) eq!
'Compound binary expression' ( 10 20 30 * + ) ( 610 ) eq!

// stack shuffling
'dup' ( 2 dup ) ( 2 2 ) eq2!
'dip' ( 2 3 4 10 ( + * ) dip ) ( 14 10 ) eq2!
'drop' ( 1 100 1000 drop ) ( 1 100 ) eq2!
'swap' ( 20 50 swap ) ( 50 20 ) eq2!
// some library words
'nip' ( 5 7 9 nip ) ( 5 9 ) eq2!
'dip2' ( 1 2 3 4 5 ( + ) dip2 ) ( 1 5 4 5 ) eq4!
'drop3' ( 1 2 3 4 drop3 ) ( 1 ) eq!
'swapd' ( 5 6 7 swapd ) ( 6 5 7 ) eq3!
'-rotd' ( 1 2 3 4 rotd ) ( 2 3 1 4 ) eq4!
'reach' ( 1 2 3 4 reach ) ( 1 2 3 4 1 ) eq5!
'keep' ( 20 30 ( * ) keep ) ( 600 30 ) eq2!

// control flow
'? for ternary choice' ( true 10 100 ? false 20 200 ? ) ( 10 200 ) eq2!
'if conditional' ( 10 true ( 20 + ) ( 50 + ) if ) ( 30 ) eq!
'when conditional' ( 10 true ( 20 + ) when false ( 100 * ) when ) ( 30 ) eq!
'unless conditional' ( 10 true ( 20 + ) unless false ( 100 * ) unless ) ( 1000 ) eq!
'call' ( 10 ( 100 * ) call ) ( 1000 ) eq!
// combinators
square : dup *
'twice' ( 3 ( square ) twice ) ( 81 ) eq!
'thrice' ( 2 ( square ) thrice ) ( 256 ) eq!
'bi' ( 5 ( 2 + ) ( square ) bi ) ( 7 25 ) eq2!
'tri' ( 5 ( 2 + ) ( square ) ( dup + ) tri ) ( 7 25 10 ) eq3!
'quad' ( 5 ( 2 + ) ( square ) ( dup + ) ( 2 - ) quad ) ( 7 25 10 3 ) eq4!

// list operations
'nth access' ( [ 1 2 3 4 5 ] 2 nth ) ( 3 ) eq!
'nth mutation' ( [ 1 2 3 4 5 ] 2 100 nth! ) ( [ 1 2 100 4 5 ] ) eq!
'length' ( [ 1 2 3 4 5 ] len ) ( 5 ) eq!
'empty?' ( [ ] empty? [ 1 2 ] empty? ) ( true false ) eq2!
// iterators
'each-integer' ( 5 ( dup + ) each-integer ) ( 0 2 4 6 8 ) eq5!
'reduce' ( [ 2 3 4 5 ] ( square + ) 1000 reduce ) ( 1054 ) eq!
'map' ( [ 2 3 4 5 ] ( dup + ) map ) ( [ 4 6 8 10 ] ) eq!
'filter' ( [ 1 10 2 4 3 6 ] ( even? ) filter ) ( [ 10 2 4 6 ] ) eq!
'slice' ( [ 1 2 3 4 5 6 7 8 9 10 ] 3 7 slice ) ( [ 4 5 6 7 ] ) eq!
'sum' ( [ 10 20 30 1 ] sum ) ( 61 ) eq!
'prod' ( [ 2 3 4 5 ] prod ) ( 120 ) eq!

// library functions
'list2' ( 10 20 list2 ) ( [ 10 20 ] ) eq!
'list5' ( 5 4 3 2 100 list5 ) ( [ 5 4 3 2 100 ] ) eq!
// sequencers
'generic a..b:c' ( 2 20 3 a..b:c ) ( [ 2 5 8 11 14 17 ] ) eq!
'seq, nat' ( 5 ( seq ) ( nat ) bi ) ( [ 0 1 2 3 4 ] [ 1 2 3 4 5 ] ) eq2!

'Final stack (should be empty):' print .s

