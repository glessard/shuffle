import XCTest
@testable import shuffleTests

XCTMain([
     testCase(FunctionalityTests.allTests),
     testCase(ShufflePerformanceTests.allTests),
])
