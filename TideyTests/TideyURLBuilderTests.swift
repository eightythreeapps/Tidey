//
//  TideyURLBuilderTests.swift
//  TideyTests
//
//  Created by Ben Reed on 22/09/2023.
//

import XCTest
@testable import Tidey

final class TideyURLBuilderTests: XCTestCase {

    var urlHelper:URLHelper!
    let host = "admiraltyapi.azure-api.net"
    
    override func setUpWithError() throws {
        self.urlHelper = URLHelper()
        XCTAssertNotNil(self.urlHelper, "URL Helper should not be nil")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.urlHelper = nil
    }

    func testBuildBasicURL() throws {
        
        let url = try? self.urlHelper.requestUrl(host: host)
        
        XCTAssert(url?.scheme == HTTPScheme.https.rawValue, "URL scheme should be HTTPS")
        XCTAssert(url?.host() == host, "Host should match input host")
        XCTAssertTrue(url!.pathComponents.isEmpty, "Path components should be empty")
    }
    
    func testBadURLError() throws {
        XCTAssertThrowsError(try urlHelper.requestUrl(host: host, path: "uktidalapi"))
    }
    
    func testBuildURLWithValidPath() throws {
        let url = try? self.urlHelper.requestUrl(host: host, path: "/pathSection")
        XCTAssertNotNil(url?.pathComponents, "Path components should not be nil")
        XCTAssertTrue(url?.pathComponents.count == 2, "Path should have 2 components")
        XCTAssertTrue(url?.path() == "/pathSection", "Path should match input")
    }
    
    func testBuildURLWithInvalidPath() throws {
        let url = try? self.urlHelper.requestUrl(host: host, path: "pathSection")
        XCTAssertNil(url, "URL should be nil")
    }
    
    func testBuildURLWithParameters() throws {
        
        let queryParams = [
            URLQueryItem(name: "param1", value: "param1Value"),
            URLQueryItem(name: "param2", value: "param2Value")
        ]
        
        let url = try? self.urlHelper.requestUrl(host: self.host, queryParams: queryParams)
        XCTAssertNotNil(url?.query(), "Query should not be nil")
        XCTAssertTrue(url?.query() == "param1=param1Value&param2=param2Value")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
