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

final class TideyAPITests: CombineTestCase {

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
    
    func testTooManyRequests() throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockTooManyResponses.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Too Many Requests")
        
        tideDataLoadable.getStations().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error as? NetworkServiceError
            }
            expectation.fulfill()
        } receiveValue: { tideStations in
            result = tideStations
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)

        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(returnedError, "Error should be of NetworkServiceError type")
        XCTAssertTrue(returnedError == .tooManyRequests, "Error shoud be Too Many Requests")
        
    }
    
    func testNotFound() throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockNotFound.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Not Found Test")
        
        tideDataLoadable.getStations().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error as? NetworkServiceError
            }
            expectation.fulfill()
        } receiveValue: { tideStations in
            result = tideStations
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)

        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(returnedError, "Error should be of NetworkServiceError type")
        XCTAssertTrue(returnedError == .notFound, "Error shoud be Not Found")
        
    }
    
    func testNotAuthorised() throws {

        let tideDataLoadable = createMockLoadable(ofType: MockNotAuthorised.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Not Authorised Test")
        
        tideDataLoadable.getStations().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error as? NetworkServiceError
            }
            expectation.fulfill()
        } receiveValue: { tideStations in
            result = tideStations
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)

        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(returnedError, "Error should be of NetworkServiceError type")
        XCTAssertTrue(returnedError == .unauthorised, "Error shoud be Unathorized")
        
    }
    
    func testServerError() throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockServerError.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Server Error Test")
        
        tideDataLoadable.getStations().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error as? NetworkServiceError
            }
            expectation.fulfill()
        } receiveValue: { tideStations in
            result = tideStations
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)

        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(returnedError, "Error should be of NetworkServiceError type")
        XCTAssertTrue(returnedError == .serverError, "Error shoud Server Error")
        
    }
    
    func testForbidden() throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockForbidden.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Forbidden Test")
        
        tideDataLoadable.getStations().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error as? NetworkServiceError
            }
            expectation.fulfill()
        } receiveValue: { tideStations in
            result = tideStations
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)

        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(returnedError, "Error should be of NetworkServiceError type")
        XCTAssertTrue(returnedError == .forbidden, "Error shoud be Forbidden")
    }
    
    func testSuccessfulTideStationResponse() throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockSuccessForTideStations.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Test successful tide stations response")
        
        tideDataLoadable.getStations().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error as? NetworkServiceError
            }
            expectation.fulfill()
        } receiveValue: { tideStations in
            result = tideStations
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)

        XCTAssertNotNil(result, "Result should not be nil")
        XCTAssertNil(returnedError, "Error should be nil")

    }
    
    func testSuccessfulTideStationEventsResponse() throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockSuccessForTideStations.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Test successful tide stations response")
        
        tideDataLoadable.getStations().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error as? NetworkServiceError
            }
            expectation.fulfill()
        } receiveValue: { tideStations in
            result = tideStations
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)

        XCTAssertNotNil(result, "Result should not be nil")
        XCTAssertNil(returnedError, "Error should be nil")
        
    }
    
    func testBadDataInTideStationResponse() throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockBadDataInTideStationList.self)
        var result:[TideStation]?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Test successful tide stations response")
        
        tideDataLoadable.getStations().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error as? NetworkServiceError
            }
            expectation.fulfill()
        } receiveValue: { tideStations in
            result = tideStations
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)

        XCTAssertNil(result, "Result should be nil")
        XCTAssertNotNil(returnedError, "Error should be of NetworkServiceError type")
        XCTAssertTrue(returnedError == .parsingError, "Error be Parsing Error")
        

    }
    
    func testSuccessfulGetStationById() throws {
        
        let tideDataLoadable = createMockLoadable(ofType: MockSuccessfulTideStationDetail.self)
        var result:TideStation?
        var returnedError:NetworkServiceError?
        
        let expectation = self.expectation(description: "Test successful tide stations response")
        
        tideDataLoadable.getStation(stationId: "0011").sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error as? NetworkServiceError
            }
            expectation.fulfill()
        } receiveValue: { tideStation in
            result = tideStation
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)

        XCTAssertNotNil(result, "Result should not be nil")
        XCTAssertNil(returnedError, "Error should be nil")
       
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
