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

extension MutableCollection
{
  mutating public func shuffle()
  {
    var step = startIndex
    let last = endIndex

    while step < last
    {
      // select a random Index from the rest of the array
#if os(Linux)
      // with slight modulo bias
      let offset = random() % numericCast(distance(from: step, to: last))
#else
      let offset = arc4random_uniform(numericCast(distance(from: step, to: last)))
#endif
      let j = index(step, offsetBy: numericCast(offset))

      // swap the element at the random Index with the element at the current step
      if step != j
      {
#if swift(>=3.2)
        self.swapAt(j,step)
#else
        swap(&self[step], &self[j])
#endif
      }

      step = self.index(after: step)
    }
  }
}
