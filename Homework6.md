1. What is the difference between <<- and <-? 

`<-` is used in any expression context. It is called an assignment operator. It creates (or modifies, as we shall see) a _binding_. A
_binding_ is a relationship between a name and a value. 
`<<-` is different from `<-` because it modifies the binding in the lexical environment/
 surrounding the current environment.  

In other words, `<-` creates a binding in the _inner_ function
environment. It doesn't _update_ the parent environment's
_value_; whereas, `<<-` does. 

2. If we type `1:10` into R we get `c(1,2,3,4,5,6,7,8,9,10)`. We added Rule 6 to account for this behavior. Did we need to?

Rule 6 is as follows: <expr1>:<expr> produces a sequence of numbers called an array
   starting at <expr1> and ending at <expr2>.
We do need this rule. Otherwise, when evaluating the program, the terminal would not know what : meant. 

3. Given the following code: 
`test_value <- 10;
for(x in 1:100){
    test_value <- x;
}
test_value`

What can you conclude about the *environment* where the body of the for loop is interpreted by R? 

