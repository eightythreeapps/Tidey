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
    
    let host = "admiraltyapi.azure-api.net"
    var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    let waitTimeout = 10.0
    
    override func setUpWithError() throws {
       
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTooManyRequests() async throws {
        
        let tideDataApi = createMockAPI(ofType: MockTooManyResponses.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Too Many Requests")
        
        do {
            result = try await tideDataApi.getStations()
        } catch {
            returnedError = error as? NetworkServiceError
        }
        
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: waitTimeout)

        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(returnedError, "Error should be of NetworkServiceError type")
        XCTAssertTrue(returnedError == .tooManyRequests, "Error shoud be Too Many Requests")
        
    }
    
    func testNotFound() async throws {
        
        let tideDataAPI = createMockAPI(ofType: MockNotFound.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Not Found Test")
        
        do {
            let response = try await tideDataAPI.getStations()
        } catch {
            returnedError = error as? NetworkServiceError
        }
        
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: waitTimeout)

        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(returnedError, "Error should be of NetworkServiceError type")
        XCTAssertTrue(returnedError == .notFound, "Error shoud be Not Found")
        
    }
    
    func testNotAuthorised() async throws {

        let tideDataAPI = createMockAPI(ofType: MockNotAuthorised.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Not Authorised Test")
        
        do {
            result = try await tideDataAPI.getStations()
        } catch {
            returnedError = error as? NetworkServiceError
        }
            
        await fulfillment(of: [expectation], timeout: waitTimeout)

        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(returnedError, "Error should be of NetworkServiceError type")
        XCTAssertTrue(returnedError == .unauthorised, "Error shoud be Unathorized")
        
    }
    
    func testServerError() async throws {
        
        let tideDataAPI = createMockAPI(ofType: MockServerError.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Server Error Test")
        
        do {
            result = try await tideDataAPI.getStations()
        } catch {
            returnedError = error as? NetworkServiceError
        }
        
        await fulfillment(of: [expectation], timeout: waitTimeout)

        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(returnedError, "Error should be of NetworkServiceError type")
        XCTAssertTrue(returnedError == .serverError, "Error shoud Server Error")
        
    }
    
    func testForbidden() async throws {
        
        let tideDataAPI = createMockAPI(ofType: MockForbidden.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Forbidden Test")
        
        do {
            result = try await tideDataAPI.getStations()
        } catch {
            returnedError = error as? NetworkServiceError
        }
        
        await fulfillment(of: [expectation], timeout: waitTimeout)
    
        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(returnedError, "Error should be of NetworkServiceError type")
        XCTAssertTrue(returnedError == .forbidden, "Error shoud be Forbidden")
    }
    
    func testSuccessfulTideStationResponse() async throws {
        
        let tideDataAPI = createMockAPI(ofType: MockSuccessForTideStations.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Test successful tide stations response")
        
        do {
            result = try await tideDataAPI.getStations()
        } catch {
            returnedError = error as? NetworkServiceError
        }
        
        await fulfillment(of: [expectation], timeout: waitTimeout)
        
        XCTAssertNotNil(result, "Result should not be nil")
        XCTAssertNil(returnedError, "Error should be nil")

    }
    
    func testSuccessfulTideStationEventsResponse() async throws {
        
        let tideDataAPI = createMockAPI(ofType: MockSuccessForTideStations.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Test successful tide stations response")
        
        do {
            result = try await tideDataAPI.getStations()
        } catch {
            returnedError = error as? NetworkServiceError
        }
        
        await fulfillment(of: [expectation], timeout: waitTimeout)

        XCTAssertNotNil(result, "Result should not be nil")
        XCTAssertNil(returnedError, "Error should be nil")
        
    }
    
    func testBadDataInTideStationResponse() async throws {
        
        let tideDataAPI = createMockAPI(ofType: MockBadDataInTideStationList.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Test successful tide stations response")
        
        do {
            result = try await tideDataAPI.getStations()
        } catch {
            returnedError = error as? NetworkServiceError
        }
                
        await fulfillment(of: [expectation], timeout: waitTimeout)

        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(returnedError, "Error should be of NetworkServiceError type")
        XCTAssertTrue(returnedError == .parsingError, "Error be Parsing Error")
        

    }
    
    func testSuccessfulGetStationById() async throws {
        
        let tideDataAPI = createMockAPI(ofType: MockSuccessfulTideStationDetail.self)
        var result:TideStation?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Test successful tide stations response")
        
        do {
            result = try await tideDataAPI.getStation(stationId: "0011")
        } catch {
            returnedError = error as? NetworkServiceError
        }
        
        await fulfillment(of: [expectation], timeout: waitTimeout)
    
        XCTAssertNotNil(result, "Result should not be nil")
        XCTAssertNil(returnedError, "Error should be nil")
       
    }
    
    func testSessionHeaders() async throws {
        
        let tideDataApi = TideDataAPI(host: self.host, dataParser: TideDataGeoJSONParser(), apiKey: "APIKEY")
        
        let headers = tideDataApi.defaultHeaders
        XCTAssertNotNil(headers, "Additional HTTP headers should not be nil")
        
        XCTAssertTrue(headers.count == 1, "Additional headers shold only contain a single value")
        
        let header = tideDataApi.defaultHeaders.first(where: { $0.name == "Ocp-Apim-Subscription-Key" })
        XCTAssertNotNil(header, "Subscription Key header should not be nil")
        XCTAssertTrue(header?.value == "APIKEY")
    
    }

}

private extension TideyAPITests {
    func createMockAPI(ofType type:AnyClass) -> TideDataAPI {
        
        URLProtocol.registerClass(type)
        let mockConfig = URLSessionConfiguration.ephemeral
    
        mockConfig.protocolClasses?.insert(type, at: 0)
        let session = URLSession(configuration: mockConfig)
        
        let tideDataAPI = TideDataAPI(host: self.host, dataParser: TideDataGeoJSONParser(), apiKey: "")
        
        XCTAssertNotNil(tideDataAPI.host, "BaseURL should not be nil")
        XCTAssertTrue(tideDataAPI.host == self.host, "Base URL should match input base URL")

        return tideDataAPI
    }
}
