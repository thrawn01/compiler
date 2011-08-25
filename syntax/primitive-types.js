
// Work in progress
def(filter, Function<Array<Int>, (Array<Int> items)>, FilterFunction condition, {
  def(i,Int,0)
  def(j,Int,0)
  def(result,Array<Int>,Array<Int,5>())

  return loop( {
    if(greater-than(length(items),i),{ 
      return result
    })
    if(condition(items[i]), {
       assign(result[j],1) // difference between assign and def?
    })
  })
      
// Code here
})
