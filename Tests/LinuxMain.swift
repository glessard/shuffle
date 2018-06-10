import XCTest
@testable import ShuffleTests

XCTMain([
  testCase(Example.allTests),
  testCase(FunctionalityTests.allTests),
  testCase(ShufflePerformanceTests.allTests),
  testCase(LazyShufflePerformanceTests.allTests),
])
