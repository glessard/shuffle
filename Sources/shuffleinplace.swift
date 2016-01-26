//
//  shuffleinplace.swift
//
//  Created by Guillaume Lessard on 2014-08-28.
//  Copyright (c) 2014 Guillaume Lessard. All rights reserved.
//

#if os(Linux)
import Glibc
#else
import func Darwin.C.stdlib.arc4random_uniform
#endif

extension MutableCollectionType where Self.Index == Int
{
  mutating public func shuffleInPlace()
  {
    var index = startIndex
    let count = endIndex - index

    while index < endIndex
    {
#if os(Linux)
      let j = index + Int(random() % (count-index)) // with slight modulo bias
#else
      let j = index + Int(arc4random_uniform(UInt32(count-index)))
#endif

      if index != j
      {
        (self[index], self[j]) = (self[j], self[index])
      }

      index += 1
    }
  }
}

extension MutableCollectionType
{
  mutating public func shuffleInPlace()
  {
    for (i, j) in zip(indices, IndexShuffler(indices))
    {
      (self[j], self[i]) = (self[i], self[j])
    }
  }
}
