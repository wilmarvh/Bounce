import XCTest
@testable import NothingButNet

class NothingButNetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    public func makeExpectation(_ callingFunctionName: String) -> XCTestExpectation {
        return expectation(description: "Expectation failure for \(callingFunctionName)")
    }
    
//    func testFetchUser() {
//        let expectation = makeExpectation(#function)
//        
//        NothingBut.Net.fetchCurrentUser { user, error in
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5, handler: { error in
//            if let error = error {
//                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//            }
//        })
//    }
    
    func testPopularShots() {
        let expectation = makeExpectation(#function)
        
        NothingBut.Net.fetchPopularShots { shots, error in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        })
    }
    
}
