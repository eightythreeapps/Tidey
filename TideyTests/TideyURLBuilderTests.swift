//
//  TideyURLBuilderTests.swift
//  TideyTests
//
//  Created by Ben Reed on 22/09/2023.
//

import XCTest
import Combine
@testable import Tidey

final class TideyURLBuilderTests: XCTestCase {

    var urlHelper:URLHelper!
    let host = "admiraltyapi.azure-api.net"
    
    var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        self.urlHelper = URLHelper()
        XCTAssertNotNil(self.urlHelper, "URL Helper should not be nil")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.urlHelper = nil
    }

    func testBuildBasicURL() throws {
        
        var urlRequest:URLRequest?
        var returnedError: Error?
        let expectation = self.expectation(description: "Build base URL")
        
        urlHelper.requestUrl(host: host)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    returnedError = error
                }
                expectation.fulfill()
            } receiveValue: { request in
                urlRequest = request
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(returnedError, "Error should be nil")
        XCTAssertNotNil(urlRequest, "URLRequest should not be nil")
        XCTAssert(urlRequest?.url?.scheme == HTTPScheme.https.rawValue, "URL scheme should be HTTPS")
        XCTAssert(urlRequest?.url?.host() == self.host, "Host should match input host")
        XCTAssertTrue(urlRequest!.url!.pathComponents.isEmpty, "Path components should be empty")
        
    }
    
    func testBadURLError() throws {
        
        var urlRequest:URLRequest?
        var returnedError: NetworkServiceError?
        let expectation = self.expectation(description: "Bad URL Test")
        
        urlHelper.requestUrl(host: host, path: "uktidalapi").sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error as? NetworkServiceError
            }
            expectation.fulfill()
        } receiveValue: { request in
            urlRequest = request
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(urlRequest, "URLRequest should not be created")
        XCTAssertNotNil(returnedError, "Error should be returned")
        XCTAssertEqual(returnedError, NetworkServiceError.badUrl, "Error type should be of type NetworkServiceError.badUrl")
    }
    
    func testBuildURLWithValidPath() throws {
        
        var urlRequest:URLRequest?
        var returnedError: Error?
        let expectation = self.expectation(description: "Build URL with valid path")
        let pathSection = "/pathSection"
        
        urlHelper.requestUrl(host: host, path: pathSection)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    returnedError = error
                }
                expectation.fulfill()
            } receiveValue: { request in
                urlRequest = request
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(returnedError, "Error should be nil")
        XCTAssertNotNil(urlRequest, "URLRequest should not be nil")
        XCTAssert(urlRequest?.url?.scheme == HTTPScheme.https.rawValue, "URL scheme should be HTTPS")
        XCTAssert(urlRequest?.url?.host() == self.host, "Host should match input host")
    
        XCTAssertNotNil(urlRequest?.url?.pathComponents, "Path components should not be nil")
        XCTAssertTrue(urlRequest?.url?.pathComponents.count == 2, "Path should have 2 components")
        XCTAssertTrue(urlRequest?.url?.path() == pathSection, "Path should match input")
    }
    
    func testBuildURLWithParameters() throws {
          
        var urlRequest:URLRequest?
        var returnedError: Error?
        let expectation = self.expectation(description: "Build URL with valid path")
        let pathSection = "/pathSection"
        
        let queryParams = [
            URLQueryItem(name: "param1", value: "param1Value"),
            URLQueryItem(name: "param2", value: "param2Value")
        ]
        
        urlHelper.requestUrl(host: host, path: pathSection, queryParams: queryParams)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    returnedError = error
                }
                expectation.fulfill()
            } receiveValue: { request in
                urlRequest = request
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(returnedError, "Error should be nil")
        XCTAssertNotNil(urlRequest, "URLRequest should not be nil")
        XCTAssert(urlRequest?.url?.scheme == HTTPScheme.https.rawValue, "URL scheme should be HTTPS")
        XCTAssert(urlRequest?.url?.host() == self.host, "Host should match input host")
        XCTAssertNotNil(urlRequest?.url?.pathComponents, "Path components should not be nil")
        XCTAssertTrue(urlRequest?.url?.pathComponents.count == 2, "Path should have 2 components")
        XCTAssertTrue(urlRequest?.url?.path() == pathSection, "Path should match input")
        XCTAssertNotNil(urlRequest?.url?.query(), "Query should not be nil")
        XCTAssertTrue(urlRequest?.url?.query() == "param1=param1Value&param2=param2Value")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
