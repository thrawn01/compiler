// -------------------------------------
// High level Function types and Calling Examples
// -------------------------------------

// Types begin with a capital letter
def Array<Any> filter(Array<Any> array, Function<Boolean, (Any)> condition) {
  // Code here
}

// 'typedef' to tidy up function signatures
typedef Function<Boolean (Any)> FilterFunction

def Array<Any> filter(Array<Any> array, FilterFunction){
  // Code here
}

// ------------------------------
// Calling Possiblities
// ------------------------------

// Explicit
filter(Array<Int>(1,2), {|Any e| if eq(e,1) { return true } } )

// For this example, the compiler can infer that e is of type Any
// and the return type is Boolean; by looking at the signature 
// the filter function requires
filter(Array(1,2), {|e| if eq(e,1) { return true } } )


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
filter(Array(1,2), filterFunction );


// -------------------------------------
// Symbol definition in the core language
// -------------------------------------

def(value,Float,1)
def(sqrt, Function<Boolean (Float e)>, { e * e })





// An experiment in function types and function signatures

// C++/Java like
Array<Any> filter(Array<Any> array, Function<Boolean (Any)> condition){
                    
}

// [] are type def brackets
Array[Any] filter(Array[Any] array, Function[Boolean (Any)] condition){
                
}

// Scala like
filter(array: Array[Any], condition: (Any) => Boolean) : Array[Any] {
                
}

// Scala with a java flare
Array[Any] filter(array: Array[Any], condition: (Any) => Boolean) {
                
}

// with a functional like anon function
Array[Any] filter(Array[Any] array, (Any) => Boolean condition) {
                
}

// Anthony
Array[Any] filter(Array[Any] array, Function[Boolean, Any] condition) {

}

// To tidy up function signatures
typedef Function<Boolean (Any)> FilterFunction

Array<Any> filter(Array<Any> array, FilterFunction condition) {

}

// Scala
def test(predicate: Int): Int => Int = {
  { prefix: Int => predicate + prefix }
}

// Scala simplified form
def test2(predicate: Int)(prefix: Int): Int = {
  predicate + prefix
}

// Possible Ollie form
def Func<Int (Int)> test(Int predicate) {
  { |Int prefix| predicate + prefix }
}

/*
   C++ level language should support generics
   The python/ruby level language should default to Any with the 
   option of using generics to create a specific container

   list = List(1, "2", 3) <-- is actually List<Any>(1, "2", 3)
   but if you wanted to
   list = List<Int>(1, 2, 3)

*/

/* 'lazy' means that the expression that results in a 'String message' will
   not be evaluated until used this is an example of 'pass by name' or
   'call by name'. this is an optimization
*/
def log(lazy String message) {
    if this.debug { 
        print message
    }
}

// In the following example, the string concat will only occur if the var
// 'message' is printed to the screen
log("Error '" + error + "'")

// Lazy can also be used in if/else conditions
// Inspired by Option and Box from scala/lift
def else(lazy Any expression) {
    if not this.condition {
        this.value = expression
    }
}
// Example usage
value = map.get("key").else("default-value")

// We could add 'else' and 'then' methods to the superclass of all objects 
// type 'Any' could implement these, and any subclasses could over write
// them

// You could then add type specific syntax and do stuff like
value = map if "key" else "default-value"
// 'if' would be syntax rule that calls map.if() 
// 'else' would be a syntax rule that matches Any.else()
// I'm not sure I like this at all, it would interfier with
// the normal 'if / else' syntax

// What if you ment
map = if "value" else "other value"
// but typed
map if "value" else "other value"
// consequences would be un-intentional

// There should be some syntax rules we should avoid, this will 
// lessen confusion for the user


