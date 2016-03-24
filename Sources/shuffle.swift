//
//  shuffle.swift
//
//  Created by Guillaume Lessard on 2014-08-28.
//  Copyright (c) 2016 Guillaume Lessard. All rights reserved.
//
//  https://github.com/glessard/shuffle
//  https://gist.github.com/glessard/7140fe885af3eb874e11
//

#if os(Linux)
import func Glibc.random
#else
import func Darwin.C.stdlib.arc4random_uniform
#endif

/// Get a sequence/generator that will return a collection's elements in a random order.
/// The input collection is not modified.
///
/// - parameter c: The collection to be shuffled
/// - returns: A sequence of of `c`'s elements, lazily shuffled.

public func shuffle<C: CollectionType>(c: C) -> ShuffledSequence<C>
{
  return ShuffledSequence(c)
}

public extension CollectionType
{
  /// Get a sequence/generator that will return a collection's elements in a random order.
  /// The input collection is not modified.
  ///
  /// - returns: A sequence of of `self`'s elements, lazily shuffled.

  public func shuffled() -> ShuffledSequence<Self>
  {
    return ShuffledSequence(self)
  }
}


/// A stepwise implementation of the Knuth Shuffle (a.k.a. Fisher-Yates Shuffle).
/// The input collection is not modified: the shuffling itself is done
/// using an adjunct array of indices.

public struct ShuffledSequence<C: CollectionType>: SequenceType, GeneratorType
{
  public let collection: C
  public let last: Int

  public private(set) var step: Int
  private var i: [C.Index]

  public init(_ input: C)
  {
    collection = input
    i = Array(input.indices)
    step = i.startIndex
    last = i.endIndex
  }

  public mutating func next() -> C.Generator.Element?
  {
    if step < last
    {
      // select a random Index from the rest of the array
#if os(Linux)
      let j = step + Int(random() % (last-step)) // with slight modulo bias
#else
      let j = step + Int(arc4random_uniform(UInt32(last-step)))
#endif

      // swap that Index with the Index present at the current step in the array
      if j != step
      {
        swap(&i[j], &i[step])
      }

      defer { step += 1 }
      // return the new random Element.
      return collection[i[step]]
    }

    return nil
  }

  public func underestimateCount() -> Int
  {
    return (last - step)
  }
}


/// A stepwise (lazy-ish) implementation of the Knuth Shuffle (a.k.a. Fisher-Yates Shuffle),
/// using a sequence of indices for the input. Elements (indices) from
/// the input sequence are returned in a random order until exhaustion.

public struct IndexShuffler<Index: ForwardIndexType>: SequenceType, GeneratorType
{
  public let last: Int
  public private(set) var step: Int
  private var i: [Index]

  public init<S: SequenceType where S.Generator.Element == Index>(_ input: S)
  {
    self.init(Array(input))
  }

  public init(_ input: Array<Index>)
  {
    i = input
    step = i.startIndex
    last = i.endIndex
  }

  public mutating func next() -> Index?
  {
    if step < last
    {
      // select a random Index from the rest of the array
#if os(Linux)
      let j = step + Int(random() % (last-step)) // with slight modulo bias
#else
      let j = step + Int(arc4random_uniform(UInt32(last-step)))
#endif

      // swap that Index with the Index present at the current step in the array
      if j != step
      {
        swap(&i[j], &i[step])
      }

      defer { step += 1 }
      // return the new random Index.
      return i[step]
    }

    return nil
  }

  public func underestimateCount() -> Int
  {
    return (last - step)
  }
}
