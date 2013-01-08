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
