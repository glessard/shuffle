import XCTest
@testable import ShuffleTests

XCTMain([
     testCase(FunctionalityTests.allTests),
     testCase(ShufflePerformanceTests.allTests),
])
