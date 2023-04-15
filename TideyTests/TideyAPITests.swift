//
//  TideyTests.swift
//  TideyTests
//
//  Created by Ben Reed on 14/04/2023.
//

import XCTest
@testable import Tidey

final class TideyAPITests: XCTestCase {

    var ukTidalAPIService:UKTidalAPI!
    
    override func setUpWithError() throws {
        
        guard let subscriptionKey = ProcessInfo.processInfo.environment["OcpApimSubscriptionKey"] else {
            XCTFail("No subscription key found")
            return
        }
            
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Ocp-Apim-Subscription-Key":subscriptionKey]
        
        let session = URLSession(configuration: config)
        XCTAssertNotNil(session.configuration.httpAdditionalHeaders)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.ukTidalAPIService = UKTidalAPIService(session: session,
                                                   baseURL: Bundle.main.object(key: .ukTidalApiBaseUrl),
                                                   urlHelper: URLHelper())
    }

    func testCreateURL() throws {
        
        let host = "www.testhost.com"
        let urlHelper = URLHelper()
        let requestUrl = urlHelper.requestUrl(host: "www.testhost.com")
        XCTAssertNotNil(requestUrl)
        
        if let componets = URLComponents(string: requestUrl!.absoluteString) {
            XCTAssertTrue(componets.scheme == HTTPScheme.https.rawValue)
            XCTAssertTrue(componets.host == host)
        }else{
            XCTFail("Components should not be nil")
        }
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.ukTidalAPIService = nil
    }
    
    func testCallWithNoSubscriptionKey() async throws {
        
        self.ukTidalAPIService = UKTidalAPIService(session: URLSession.shared,
                                                   baseURL: Bundle.main.object(key: .ukTidalApiBaseUrl),
                                                   urlHelper: URLHelper())
        
        do {
            let result = try await self.ukTidalAPIService.getStations()
        } catch NetworkServiceError.httpError(code: let statusCode) {
            XCTAssertTrue(statusCode == 401)
        }
    }
    
    func testGetAllStations() async throws {
        
        do {
            let result = try await self.ukTidalAPIService.getStations()
            XCTAssertNotNil(result)
        } catch {
            XCTFail("API call should succeed")
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
