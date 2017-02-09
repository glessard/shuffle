# Shuffle [![Build Status](https://travis-ci.org/glessard/shuffle.svg?branch=master)](https://travis-ci.org/glessard/shuffle)

Adds a `shuffled()` method to any implementor of `Collection`.

It shuffles the Collection as lazily as possible, without mutating the collection.
The collection's indices are copied to an array, which in turn gets shuffled.

This allows the input collection to be indexed only. In general this should minimize memory allocation, for example in cases where the size of `Element` is greater than the size of `Index`.

Example:
```
import Shuffle

let a = Array(0...4)

var stats = Array<Array<Int>>(count: a.count, repeatedValue: Array(count: a.count, repeatedValue: 0))

(0..<8000).forEach {
  _ in
  for (i,j) in a.shuffled().enumerate()  // shuffled() used here
  {
    stats[i][j] += 1
  }
}

var sums = Array<Int>(count: a.count, repeatedValue: 0)
for total in stats
{
  let t = total.reduce(0, combine: +)
  for i in 0..<sums.count
  {
    sums[i] += total[i]
  }
  print(total, t)
}
print(sums)
```

The package also adds a mutating `shuffle()` method to implementors of `MutableCollection`.
`shuffle()` shuffles the whole collection at once, trying to minimize memory usage.
