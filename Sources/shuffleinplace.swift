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

extension MutableCollectionType where Self.Index: SignedIntegerType
{
  mutating public func shuffle()
  {
    var index = startIndex
    let count = endIndex - index

    while index != endIndex
    {
#if os(Linux)
      // with slight modulo bias
      let j = index + numericCast(random() % numericCast(count-index))
#else
      let j = index + numericCast(arc4random_uniform(numericCast(count-index)))
#endif

      if index != j
      {
        (self[index], self[j]) = (self[j], self[index])
      }

      index = index.successor()
    }
  }
}

extension MutableCollectionType where Self.Index: UnsignedIntegerType
{
  mutating public func shuffle()
  {
    var index = startIndex
    let count = endIndex - index

    while index != endIndex
    {
#if os(Linux)
      // with slight modulo bias
      let j = index + numericCast(random() % numericCast(count-index))
#else
      let j = index + numericCast(arc4random_uniform(numericCast(count-index)))
#endif

      if index != j
      {
        (self[index], self[j]) = (self[j], self[index])
      }

      index = index.successor()
    }
  }
}

extension MutableCollectionType
{
  mutating public func shuffle()
  {
    for (i, j) in zip(indices, IndexShuffler(indices))
    {
      (self[j], self[i]) = (self[i], self[j])
    }
  }
}
