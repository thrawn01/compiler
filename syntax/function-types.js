// -------------------------------------
// Function types and Calling Examples
// -------------------------------------

// Types begin with a capital letter
Array<Any> filter(Array<Any> array, Function<Boolean, (Any)> condition) {
  // Code here
}

// 'typedef' to tidy up function signatures
typedef Function<Boolean (Any)> FilterFunction

// With type defs, doesn't look so ugly, C++ style might work well
def(filter, Function<Array<Boolean>, (Array<Int> items)>, FilterFunction condition) {
  // Code here
}

// ------------------------------
// Calling Possiblities
// ------------------------------

// Explicit
filter(Array<Int>(1,2), Function<Boolean (Any e)> { if eq(e,1) { return true } } )

// For this example, the compiler can infer that e is of type Any
// and the return type is Boolean; by looking at the signature 
// the filter function requires
filter(Array(1,2), Function<(e)> { if eq(e,1) { return true } } )


// Defining a named function 
def Boolean filterFunction( Any e ) {
    if e == 1 { 
        return true;
    }
}

// Return type could be infered
def filterFunction( Any e ) {
    if e == 1 { 
        return true;
    }
}

// Here the compiler doesn't have to infer the arguments of the function
filter(Array<Float>(1,2), filterFunction );


// 'def' could me a synonym for the following ( But I'm not really liking this much )
filterFunction = Function<Boolean (Any e)> { 
    if e == 1 { 
        return true;
    }
}

// -------------------------------------
// Symbol definition in the core language
// -------------------------------------

def(value,Float,1)
def(sqrt, Function<Boolean (Float e)>, { e * e })


