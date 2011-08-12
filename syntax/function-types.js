// An experiment in function types and function signatures


// Very C++ ish
Array<Any> filter( Array<Any> array, function<Boolean (Any)> condition ){
                    
}

// More Scala ish
Array[Any] filter( Array[Any] array, function[Boolean (Any)] condition ){
                
}

// More like Scala / fortran
filter( array: Array[Any], condition: (Any) => Boolean ) : Array[Any] {
                
}

// Variation on Scala/C++
Array[Any] filter( array: Array[Any], condition: (Any) => Boolean ) {
                
}

// Scala/fortran but with the names after the type defs
Array[Any] filter( Array[Any] array, (Any) => Boolean condition ) {
                
}

// Anthony's Suggestion
Array[Any] filter(Array[Any] array, Function[Boolean, Any] condition) {

}

// Should Allow 'typedef' to tidy up function signatures
typedef Function[Boolean (Any)] FilterFunction

// With type defs, doesn't look so ugly, C++ style might work well
Array[Any] filter(Array[Any] array, FilterFunction condition) {

}

// ------------------------------
// Calling Possiblities
// ------------------------------

// For this example, the compiler can infer that e is of type Any
// and the return type is Boolean; by looking at the signature 
// the filter function requires
filter([1,2], function(e) { if e == 1 { return true } })

// Or? 
filter([1,2], Function[e] { if e == 1 { return true } })
// Should we distinguish the difference between calling and defining a function?


// Using a named function
def Boolean filterFunction( Any e ) {
    if e == 1 { 
        return true;
    }
}

// Here the compiler doesn't have to infer the arguments of the function
filter([1,2], filterFunction );


// 'def' could me a synonym for the following ( But I'm not really liking this much )
filterFunction = Function[Boolean (Any e)] { 
    if e == 1 { 
        return true;
    }
}

// ===================================
// Crazy idea to create 2 meta-compiler functions 
// to handle creating functions and signatures on 
// behalf of the AST parser, this way anyone that doesn't
// like our syntax for defining a method could create their own.
// ===================================

// first argument is the return type, next is first type, then type name, repeating...
func_signature = create_function_signature(Boolean, Int, 'e')
// Then we create the function defnition
new_function = create_function( func_signature, { if e == 1 { return true } } )

// now 'new_function' is a usable function
value = new_function(1) // <-- value equals true

