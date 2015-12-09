# Shuffle

Shuffle a Collection as lazily as possible, via a `PermutationGenerator`: the collection is copied, but not mutated.

The collection's indices are copied to an array, which in turn gets shuffled.

This allows the input collection to be indexed only; in general this minimizes memory allocation, for in any case where the size of `Element` is greater than the size of `Index` (most of the time).

Example:
```
let a = Array(0...4)

var stats = Array<Array<Int>>(count: a.count, repeatedValue: Array(count: a.count, repeatedValue: 0))

(0..<8000).forEach {
  _ in
  for (i,j) in a.shuffle().enumerate()  // shuffle() used here
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
