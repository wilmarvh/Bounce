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
    
    func testFetchCurrentUser() {
        let expectation = makeExpectation(#function)
        
        User.fetchCurrent { user, error in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        })
    }
    
    func testFetchUserWithUsername() {
        let expectation = makeExpectation(#function)
        
        User.fetch(with: "wilmarvh") { user, error in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        })
    }
    
}
