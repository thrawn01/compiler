// Parser Type system ideas

for <expression> <expression>

// 'IN' takes an Iterable and assigns the first iterable to the assignable expression
<assignable-expression> in Iterable

// Usage of 'for' and 'in'
for item in list {
    print item
}

// Because 'for' takes an expression we could do stuff like this
// and only execute the second expression if the first returns true
for (item in list; if item.startswith('k')) {
    print item
}

// The implementation of 'for' could take all the available vars in the
// first expression and make them available in the second expression
// so we could do stuff like
for (item in list; upped = item.upper()) {
    print item
    print upped
}


// some syntax ideas


// first define the while function
def while(conditional, block) {
    // while implementation
}

// syntax keyword <bnf>
//  ^      ^       ^
//  |      |       ---- bnf regex
//  |      --- bnf match keyword
//  --- special form (core code keyword)

// Now define the special syntax
// instead of calling "while(1, {})
// now you can call "while 1 {}"
syntax while <some bnf parser syntax>
    // everything under 'scope' shares the same scope
   (scope 
       // Places the 'while' symbol with the conditional and block 
       // collected from the bnf parser syntax
      (while, conditional, block))


// you can specify class level methods in the AST by passing in 'this' or 'self'
(my-method, self, arg1, arg2)
// 'this' would be a special form, that refers to the class instance the AST is parsing

