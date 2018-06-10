# Shuffle [![Build Status](https://travis-ci.org/glessard/shuffle.svg?branch=master)](https://travis-ci.org/glessard/shuffle)

Adds a `shuffled()` method to any `Collection`, and a `shuffle()` method to any `MutableCollection`-- for Swift prior to 4.2

It shuffles the Collection as lazily as possible, without mutating the collection.
The collection's indices are copied to an array, which in turn gets shuffled.

This allows the input collection to be indexed only. In general this should minimize memory allocation, for example in cases where the size of `Element` is greater than the size of `Index`.

For Swift 4.2 and up, the standard library's `Collection.shuffle()` and `Collection.randomElement()` will perform much better. While it may be possible to craft examples where using the approach in this package manages to perform better, they are undoubtedly few and far between.

Example:
```
import Shuffle

let a = Array(0...4)

var stats = Array<Array<Int>>(repeating: Array(repeating: 0, count: a.count), count: a.count)

(0..<8000).forEach {
  _ in
  for (i,j) in a.shuffled().enumerated()  // shuffled() used here
  {
    stats[i][j] += 1
  }
}

var sums = Array<Int>(repeating: 0, count: a.count)
for total in stats
{
  let t = total.reduce(0, +)
  for i in 0..<sums.count
  {
    sums[i] += total[i]
  }
  print(total, t)
}
print(sums)
```
