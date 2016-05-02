//
//  shuffleinplace.swift
//
//  Created by Guillaume Lessard on 2014-08-28.
//  Copyright (c) 2016 Guillaume Lessard. All rights reserved.
//

#if os(Linux)
import func Glibc.random
#else
import func Darwin.C.stdlib.arc4random_uniform
#endif

extension MutableCollection where Self.Index: SignedInteger
{
  mutating public func shuffle()
  {
    var step = startIndex
    let last = endIndex

    while step < last
    {
#if os(Linux)
      // with slight modulo bias
      let j = step + numericCast(random() % numericCast(last-step))
#else
      let j = step + numericCast(arc4random_uniform(numericCast(last-step)))
#endif

      if step != j
      {
        (self[step], self[j]) = (self[j], self[step])
      }

      step = step.successor()
    }
  }
}

extension MutableCollection
{
  mutating public func shuffle()
  {
    for (i, j) in zip(indices, IndexShuffler(indices)) where i != j
    {
      (self[j], self[i]) = (self[i], self[j])
    }
  }
}
