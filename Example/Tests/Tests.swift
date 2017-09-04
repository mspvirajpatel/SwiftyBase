import UIKit
import XCTest
import SwiftyBase
@testable import SwiftyBase

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testClearImageData() {
        ImageDownloader.clearAllTheCachedImages()
    }
    
    func testApiCall() {
        
        let expection : XCTestExpectation = expectation(description: "Completion handler invoked")
        
        APIManager.shared.getRequest(URL: API.countries, Parameter: NSDictionary(), completionHandler:{(result) in
            
            switch result{
            case .Success(let object, _):
                print(object ?? "")
                XCTAssert(true , "Sucess")
                expection.fulfill()
                break
            case .Error(let error):
                
                print(error?.alertMessage! ?? "")
                XCTAssert(false , "Sucess")
                expection.fulfill()
                break
            case .Internet(let isOn):
                print("Internet is  \(isOn)")
                break
            }
        })
        waitForExpectations(timeout: 30, handler: nil)
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
