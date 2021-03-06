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


#if !swift(>=4.2)
#if swift(>=3.2)
public extension Collection
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
#else
public extension Collection where Self.Indices.Iterator.Element == Self.Index
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
#endif
#endif

/// A stepwise implementation of the Knuth Shuffle (a.k.a. Fisher-Yates Shuffle).
/// The input collection is not modified: the shuffling itself is done
/// using an adjunct array of indices.

#if swift(>=3.2)
public struct ShuffledSequence<C: Collection>: Sequence, IteratorProtocol
{
  public let collection: C
  private var shuffler: IndexShuffler<C.Index>

  public init(_ input: C)
  {
    collection = input
    shuffler = IndexShuffler(input.indices)
  }

  public mutating func next() -> C.Iterator.Element?
  {
    if let index = shuffler.next()
    {
      return collection[index]
    }
    return nil
  }

  public var underestimatedCount: Int {
    return shuffler.underestimatedCount
  }
}
#else
public struct ShuffledSequence<C: Collection>: Sequence, IteratorProtocol
  where C.Indices.Iterator.Element == C.Index
{
  public let collection: C
  private var shuffler: IndexShuffler<C.Index>

  public init(_ input: C)
  {
    collection = input
    shuffler = IndexShuffler(input.indices)
  }

  public mutating func next() -> C.Iterator.Element?
  {
    if let index = shuffler.next()
    {
      return collection[index]
    }
    return nil
  }

  public var underestimatedCount: Int {
    return shuffler.underestimatedCount
  }
}
#endif

/// A stepwise (lazy-ish) implementation of the Knuth Shuffle (a.k.a. Fisher-Yates Shuffle),
/// using a sequence of indices for the input. Elements (indices) from
/// the input sequence are returned in a random order until exhaustion.

public struct IndexShuffler<Index>: Sequence, IteratorProtocol
{
  public let last: Int
  public private(set) var step: Int
  private var i: [Index]

  public init<S: Sequence>(_ input: S)
    where S.Iterator.Element == Index
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
#if swift(>=4.2)
      let j = Int.random(in: step..<last)
#else
#if os(Linux)
      let offset = random() % i.distance(from: step, to: last) // with slight modulo bias
#else
      let offset = arc4random_uniform(UInt32(i.distance(from: step, to: last)))
#endif
      let j = i.index(step, offsetBy: Int(offset))
#endif

      // swap that Index with the Index present at the current step in the array
      if j != step
      {
#if swift(>=3.2)
        i.swapAt(j,step)
#else
        swap(&i[j], &i[step])
#endif
      }

      defer { step = i.index(after: step) }
      // return the new random Index.
      return i[step]
    }

    return nil
  }

  public var underestimatedCount: Int {
    return (last - step)
  }
}
