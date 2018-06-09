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
      let shuffled = a.shuffled()
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
