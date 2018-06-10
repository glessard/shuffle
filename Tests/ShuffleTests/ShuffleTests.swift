//
//  ShuffleTests.swift
//  ShuffleTests
//
//  Created by Guillaume Lessard on 2015-02-18.
//  Copyright (c) 2015 Guillaume Lessard. All rights reserved.
//

import Foundation
import XCTest

import Shuffle

class FunctionalityTests: XCTestCase
{
  static var allTests: [(String, (FunctionalityTests) -> () throws -> Void)] {
    return [
      ("testShuffle", testShuffle),
      ("testShuffleInPlace", testShuffleInPlace),
    ]
  }

  func testShuffle()
  {
    let a = Array(1...100)

    var unshuffled = 0
    let iterations = 1000
    for _ in 0..<iterations
    {
      let shuffled = ShuffledSequence(a)
      Array(shuffled) == a ? (unshuffled += 1) : (unshuffled += 0)
      XCTAssert(shuffled.sorted() == a)
    }

    if (unshuffled > 0) && (unshuffled < iterations) { print("lucky tester") }
    XCTAssert(unshuffled < iterations)
  }

  func testShuffleInPlace()
  {
    let a = Array(1...100)

    var unshuffled = 0
    let iterations = 1000
    for _ in 0..<iterations
    {
      var shuffled = a
      shuffled.shuffle()
      Array(shuffled) == a ? (unshuffled += 1) : (unshuffled += 0)
      XCTAssert(shuffled.sorted() == a)
    }

    if (unshuffled > 0) && (unshuffled < iterations) { print("lucky tester") }
    XCTAssert(unshuffled < iterations)
  }
}

class ShufflePerformanceTests: XCTestCase
{
  let a = Array(stride(from: -5.0, to: 1e5, by: 0.8))

  static var allTests: [(String, (ShufflePerformanceTests) -> () throws -> Void)] {
    return [
      ("testPerformanceControl", testPerformanceControl),
      ("testPerformanceShuffleMethod", testPerformanceShuffleMethod),
      ("testPerformanceShuffledSequence", testPerformanceShuffledSequence),
      ("testPerformanceIndexShuffler", testPerformanceIndexShuffler),
      ("testPerformanceShuffleInPlace1", testPerformanceShuffleInPlace1),
      ("testPerformanceShuffleInPlace2", testPerformanceShuffleInPlace2),
    ]
  }

  func testPerformanceControl()
  {
    let p = UnsafeMutablePointer<Double>.allocate(capacity: a.count)
    let b = UnsafeMutableBufferPointer(start: p, count: a.count)
    p.initialize(from: a, count: a.count)
    self.measure() {
      _ = Array(AnySequence(b))
    }
    p.deinitialize(count: a.count)
  #if swift(>=4.1)
    p.deallocate()
  #else
    p.deallocate(capacity: a.count)
  #endif
  }

  func testPerformanceShuffleInPlace1()
  {
    var b = a
    self.measure() {
     b.shuffle()
    }
  }

  func testPerformanceShuffleInPlace2()
  {
    let p = UnsafeMutablePointer<Double>.allocate(capacity: a.count)
    var b = UnsafeMutableBufferPointer(start: p, count: a.count)
    p.initialize(from: a, count: a.count)
    self.measure() {
      b.shuffle()
    }
    p.deinitialize(count: a.count)
  #if swift(>=4.1)
    p.deallocate()
  #else
    p.deallocate(capacity: a.count)
  #endif
  }

  func testPerformanceShuffleMethod()
  {
    self.measure() {
      _ = Array(self.a.shuffled())
    }
  }

  func testPerformanceShuffledSequence()
  {
    self.measure() {
      _ = Array(ShuffledSequence(self.a))
    }
  }

  func testPerformanceIndexShuffler()
  {
    self.measure() {
      _ = IndexShuffler(self.a.indices).map({ i in self.a[i] })
    }
  }
}

let prefixLength = 1000
let source = (0..<25000).map(Double.init(_:))

class LazyShufflePerformanceTests: XCTestCase
{
  func testPerformanceEagerPrefix()
  {
    let a = source
    self.measure() {
      let selection = Array(a.shuffled().prefix(prefixLength))
      XCTAssert(selection.count == prefixLength)
    }
  }

#if swift(>=4.2)
  func testPerformanceIterativeApproach()
  {
    let a = source
    self.measure() {
      var set = Set<Double>()
      set.reserveCapacity(prefixLength)
      while set.count < prefixLength
      {
        set.insert(a.randomElement()!)
      }
      let selection = set.shuffled()
      XCTAssert(selection.count == prefixLength)
    }
  }

  func testPerformanceIndirectIteration()
  {
    let a = source
    self.measure() {
      var set = Set<Int>()
      set.reserveCapacity(prefixLength)
      let indices = a.indices
      while set.count < prefixLength
      {
        set.insert(indices.randomElement()!)
      }
      let selection = set.map({ a[$0] }).shuffled()
      XCTAssert(selection.count == prefixLength)
    }
  }
#endif

  func testPerformanceLazyPrefix()
  {
    let a = source
    self.measure() {
      let selection = Array(ShuffledSequence(a).prefix(prefixLength))
      XCTAssert(selection.count == prefixLength)
    }
  }
}
