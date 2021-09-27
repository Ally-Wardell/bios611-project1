Homework Part 1
===============

1. What is the difference between `<<-` and `<-`?

    `<-` is used in any expression context. It is called an assignment operator. It$
    _binding_ is a relationship between a name and a value.
    `<<-` is different from `<-` because it modifies the binding in the lexical env$
    surrounding the current environment.

    In other words, `<-` creates a binding in the _inner_ function
    environment. It doesn't _update_ the parent environment's
    _value_; whereas, `<<-` does.


2. If we type `1:10` into R we get `c(1,2,3,4,5,6,7,8,9,10)`. We added
   Rule 6 to account for this behavior. Did we need to?

   Rule 6 is as follows: <expr1>:<expr> produces a sequence of numbers called an array
   starting at <expr1> and ending at <expr2>.
   We do need this rule. Otherwise, when evaluating the program, the terminal would not be able to determine what the : did in
   this context.

3. Given the following code:

```
test_value <- 10;
for(x in 1:100){
    test_value <- x;
}
test_value
```

What can you conclude about the _environment_ where the body of the
for loop is interpreted by R?

    We can conlcude that a for loop evaluates the block many times with <name> bound to subsequent values of 
    <sequence-expression>.
    test_value=100 is the result. 

4. Write a snippet to test whether `while` loops follow the same rule.

```
test_value <- 10;
while (x < 100) {
    test_value <- x;
}
test_value
```
    We can see that the while(<test>) { body0; .. bodyN } evaluates the block until <test> is F. This means that this will simply
    produce test_value=10 as the result.

5. The Fibbonoci Sequence:

   1, 1, 2, 3, 5, 8, 13, 21, 34, ...
   
   Is produced by starting with the sequence 1, 1. The nth value is
   then defined as the sum of the 2 previous values.
   
   Write a function `make_fib_counter` which returns a function which
   gives successive fibonocci numbers upon repeated invocation.

```
make_fib_counter <- function(c1, c2){
    new_c1 <- c1;
    new_c2 <- c2
    function(){
        old_c1 <- new_c1;
        old_c2 <- new_c2;
        new_c1 <<-  new_c2; ## Update the old value in the parent scope.
        new_c2 <<- old_c1 + old_c2
        new_c2
    }
}


fib_counter <- make_fib_counter(1,1);
fib_counter()
fib_counter()

etc...
```
   
6. The sequence (1,1) constitutes the initial condition for the
   Fibbonoci sequence. Write a second function that produces a
   function which counts up a sequence generated with an arbitrary
   initial condition.
   
   Something like this:
   
   ```
   make_nocci <- function(c1, c2){
      function(){
           <fun part here>
       }
       }
   ```


```
make_nocci <- function(c1, c2){
    new_c1 <- c1;
    new_c2 <- c2
    function(){
        old_c1 <- new_c1;
        old_c2 <- new_c2;
        new_c1 <<-  new_c2; ## Update the old value in the parent scope.
        new_c2 <<- old_c1 + old_c2
        new_c2
    }
}

counter <- make_nocci(2,3);
counter()
etc...
```
