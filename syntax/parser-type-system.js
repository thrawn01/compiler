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
