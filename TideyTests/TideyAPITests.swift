//
//  TideyTests.swift
//  TideyTests
//
//  Created by Ben Reed on 14/04/2023.
//

import XCTest
import Combine
@testable import Tidey

final class TideyAPITests: XCTestCase {

    var tidalDataSource:TideDataLoadable!
    var cancellables = Set<AnyCancellable>()
    
    let baseURL = "https://admiraltyapi.azure-api.net"
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.tidalDataSource = nil
    }
    
    func createMockLoadable(ofType type:AnyClass) -> TideDataLoadable {
        URLProtocol.registerClass(type)
        let mockConfig = URLSessionConfiguration.ephemeral
    
        mockConfig.protocolClasses?.insert(type, at: 0)
        let session = URLSession(configuration: mockConfig)
        
        let tideDataLoadable = UKTidalAPI(session: session, baseURL: self.baseURL, urlHelper: URLHelper())
        XCTAssertNotNil(tideDataLoadable.baseUrl, "BaseURL should not be nil")
        XCTAssertTrue(tideDataLoadable.baseUrl == self.baseURL, "Base URL should match input base URL")

        
        return tideDataLoadable
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
    
    func testSessionHeaders() async throws {
        
        let session = URLSession.shared
        let tideDataLoadable = UKTidalAPI(apiKey: "APIKEY")
        
        let headers = tideDataLoadable.session.configuration.httpAdditionalHeaders
        XCTAssertNotNil(headers, "Additional HTTP headers should not be nil")
        
        XCTAssertTrue(headers?.count == 1, "Additional headers shold only contain a single value")
        
        let header = tideDataLoadable.session.configuration.httpAdditionalHeaders?.first(where: { $0.key as! String == "Ocp-Apim-Subscription-Key" })
        XCTAssertNotNil(header, "Subscription Key header should not be nil")
        XCTAssertTrue(header?.value as! String == "APIKEY")
    
    }
}
