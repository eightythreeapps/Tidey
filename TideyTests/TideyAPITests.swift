//
//  TideyTests.swift
//  TideyTests
//
//  Created by Ben Reed on 14/04/2023.
//

import XCTest
import Combine
import CoreLocation
@testable import Tidey

final class TideyAPITests: XCTestCase {

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
    
    func testTooManyRequests() async throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockTooManyResponses.self)
        
        do {
            let _ = try await tideDataLoadable.getStations()
        }catch {
            XCTAssertTrue(((error as? NetworkServiceError) != nil), "Error should be of NetworkServiceError type")
            XCTAssertTrue((error as? NetworkServiceError) == .tooManyRequests, "Error shoud be Too Many Requests")
        }
        
    }
    
    func testNotFound() async throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockNotFound.self)
        
        do {
            let _ = try await tideDataLoadable.getStations()
        }catch {
            XCTAssertTrue(((error as? NetworkServiceError) != nil), "Error should be of NetworkServiceError type")
            XCTAssertTrue((error as? NetworkServiceError) == .notFound, "Error shoud be Not Found")
        }
        
    }
    
    func testNotAuthorised() async throws {
       
        let tideDataLoadable = createMockLoadable(ofType: MockNotAuthorised.self)
        
        do {
            let _ = try await tideDataLoadable.getStations()
        }catch {
            XCTAssertTrue(((error as? NetworkServiceError) != nil), "Error should be of NetworkServiceError type")
            XCTAssertTrue((error as? NetworkServiceError) == .unauthorised, "Error shoud be Unathorized")
        }
        
    }
    
    func testServerError() async throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockServerError.self)
        
        do {
            let _ = try await tideDataLoadable.getStations()
        }catch {
            XCTAssertTrue(((error as? NetworkServiceError) != nil), "Error should be of NetworkServiceError type")
            XCTAssertTrue((error as? NetworkServiceError) == .serverError, "Error shoud Server Error")
        }
        
    }
    
    func testForbidden() async throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockForbidden.self)
        
        do {
            let _ = try await tideDataLoadable.getStations()
        }catch {
            XCTAssertTrue(((error as? NetworkServiceError) != nil), "Error should be of NetworkServiceError type")
            XCTAssertTrue((error as? NetworkServiceError) == .forbidden, "Error shoud Server Error")
        }
        
    }
    
    func testSuccessfulTideStationResponse() async throws {
        
        let expectation = XCTestExpectation(description: "Tide Station Data should be successfully returned")
        let tideDataLoadable = createMockLoadable(ofType: MockSuccessForTideStations.self)
        
        do {
            let stations = try await tideDataLoadable.getStations()
            XCTAssertNotNil(stations, "Stations list should be populated")
            expectation.fulfill()
        }catch {
            XCTFail("API call should succeed")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testSuccessfulTideStationEventsResponse() async throws {
        
        let expectation = XCTestExpectation(description: "Tide Station Data should be successfully returned")

        let tideDataLoadable = createMockLoadable(ofType: MockSuccessForTideStationEvents.self)
        
        do {
            let stations = try await tideDataLoadable.getTidalEvents(stationId: "0011")
            XCTAssertNotNil(stations, "Stations list should be populated")
            expectation.fulfill()
        }catch {
            XCTFail("API call should succeed")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testBadDataInTideStationResponse() async throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockBadDataInTideStationList.self)
        
        do {
            let _ = try await tideDataLoadable.getStations()
        }catch {
            XCTAssertTrue(((error as? NetworkServiceError) != nil), "Error should be of NetworkServiceError type")
            XCTAssertTrue((error as? NetworkServiceError) == .parsingError, "Error be Parsing Error")
        }
        
    }
    
    func testSuccessfulGetStationById() async throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockSuccessfulTideStationDetail.self)
        
        do {
            let station = try await tideDataLoadable.getStation(stationId: "0011")
            XCTAssertNotNil(station, "Station should not be nil")
        }catch {
            XCTAssertTrue(((error as? NetworkServiceError) != nil), "Error should be of NetworkServiceError type")
            XCTAssertTrue((error as? NetworkServiceError) == .parsingError, "Error be Parsing Error")
        }
        
    }
    
    func testSessionHeaders() async throws {
        
        let tideDataLoadable = TideDataAPI(apiKey: "APIKEY")
        
        let headers = tideDataLoadable.session.configuration.httpAdditionalHeaders
        XCTAssertNotNil(headers, "Additional HTTP headers should not be nil")
        
        XCTAssertTrue(headers?.count == 1, "Additional headers shold only contain a single value")
        
        let header = tideDataLoadable.session.configuration.httpAdditionalHeaders?.first(where: { $0.key as! String == "Ocp-Apim-Subscription-Key" })
        XCTAssertNotNil(header, "Subscription Key header should not be nil")
        XCTAssertTrue(header?.value as! String == "APIKEY")
    
    }
    
    func testHTTPMehtodEnum() throws {
        
        let post = HTTPMethod.post
        XCTAssertNotNil(post.stringValue(), "String value should not be nil")
        XCTAssertEqual(post.stringValue(), "POST", "Value should be post")
    
        let get = HTTPMethod.get
        XCTAssertNotNil(get.stringValue(), "String value should not be nil")
        XCTAssertEqual(get.stringValue(), "GET", "Value should be post")
        
    }
    
    func testGetNearestTideStation() async throws {
        
        let expectation = XCTestExpectation(description: "Tide Station Data should be successfully returned")
        let tideDataLoadable = createMockLoadable(ofType: MockSuccessForTideStations.self)
        
        do {
            
            let stations = try await tideDataLoadable.getStations()
            XCTAssertNotNil(stations, "Stations list should be populated")
            
            let userLocation = CLLocation(latitude: 50.3377, longitude: -4.77784)
            let station = stations.getNearestStation(to: userLocation)
            XCTAssertTrue(station?.getStationName() == "Par")
            
            expectation.fulfill()
        }catch {
            XCTFail("API call should succeed")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
        
    }

}

private extension TideyAPITests {
    func createMockLoadable(ofType type:AnyClass) -> TideDataAPI {
        
        URLProtocol.registerClass(type)
        let mockConfig = URLSessionConfiguration.ephemeral
    
        mockConfig.protocolClasses?.insert(type, at: 0)
        let session = URLSession(configuration: mockConfig)
        
        let tideDataLoadable = TideDataAPI(session: session, host: self.host, urlHelper: URLHelper())
        XCTAssertNotNil(tideDataLoadable.host, "BaseURL should not be nil")
        XCTAssertTrue(tideDataLoadable.host == self.host, "Base URL should match input base URL")

        return tideDataLoadable
    }
}
