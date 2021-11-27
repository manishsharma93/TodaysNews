//
//  TodayNewsTests.swift
//  TodayNewsTests
//
//  Created by manish on 27/11/21.
//

import XCTest
@testable import TodayNews

class TodayNewsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //Test case to fetch movie listing data
    func testMovieListingDataFetch() {
        let params = [
            "country" : "us",
            "category" : Appkeys.APP_NEWS_CATEGORY,
            "apiKey" : Appkeys.APP_API_KEY,
            "pageSize" : 5,
            "page" : 1
            ] as [String : Any]
        
        // When
        Webservices().callGetService(methodName: WebServiceMethods.WS_TOP_HEADLINES, params: params, successBlock: { (data) in
            do {
                // Then
                XCTAssertNotNil(data)
            }
        }) { (error) in
            
        }
    }

}
