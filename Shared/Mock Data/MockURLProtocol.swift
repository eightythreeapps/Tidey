//
//  MockURLProtocol.swift
//  TideyTests
//
//  Created by Ben Reed on 27/04/2023.
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
        
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
    
    public func generateResponse(for statusCode:Int, data:Data? = nil) -> (HTTPURLResponse, Data?) {
        
        let response = HTTPURLResponse.init(url: request.url!, statusCode: statusCode, httpVersion: "2.0", headerFields: nil)!
        return (response, data)
        
    }
    
}

class MockTooManyResponses: MockURLProtocol {
    override func startLoading() {
        
        MockTooManyResponses.requestHandler = { request in
            return self.generateResponse(for: 429)
        }
        
        super.startLoading()
    }
}


class MockNotFound: MockURLProtocol {
    override func startLoading() {
        
        MockNotFound.requestHandler = { request in
            return self.generateResponse(for: 404)
        }
        
        super.startLoading()
    }
}

class MockNotAuthorised: MockURLProtocol {
    override func startLoading() {
        
        MockNotAuthorised.requestHandler = { request in
            return self.generateResponse(for: 401)
        }
        
        super.startLoading()
    }
}


class MockForbidden: MockURLProtocol {
    override func startLoading() {
        
        MockNotAuthorised.requestHandler = { request in
            return self.generateResponse(for: 403)
        }
        
        super.startLoading()
    }
}


class MockServerError: MockURLProtocol {
    override func startLoading() {
        
        MockServerError.requestHandler = { request in
            return self.generateResponse(for: 500)
        }
        
        super.startLoading()
    }
}


class MockSuccessForTideStations: MockURLProtocol {
    override func startLoading() {
        
        MockSuccessForTideStations.requestHandler = { request in
            let data = FileHelper.loadLocalJSON(fileType: .tideStations)
            return self.generateResponse(for: 200, data: data)
        }
        
        super.startLoading()
    }
}

class MockSuccessForTideStationEvents: MockURLProtocol {
    override func startLoading() {
        
        MockSuccessForTideStationEvents.requestHandler = { request in
            let data = FileHelper.loadLocalJSON(fileType: .tidalEvents)
            return self.generateResponse(for: 200, data: data)
        }
        
        super.startLoading()
    }
}

class MockBadDataInTideStationList: MockURLProtocol {
    override func startLoading() {
        
        MockBadDataInTideStationList.requestHandler = { request in
            let data = FileHelper.loadLocalJSON(fileType: .tideStationsBad)
            return self.generateResponse(for: 200, data: data)
        }
        
        super.startLoading()
    }
}

class MockSuccessfulTideStationDetail: MockURLProtocol {
    override func startLoading() {
        
        MockSuccessfulTideStationDetail.requestHandler = { request in
            let data = FileHelper.loadLocalJSON(fileType: .station)
            return self.generateResponse(for: 200, data: data)
        }
        
        super.startLoading()
    }
}
