//
//  TideyLocationServiceTests.swift
//  TideyTests
//
//  Created by Ben Reed on 10/05/2023.
//

import XCTest
import Combine
import CoreLocation
@testable import Tidey

final class TideyLocationServiceTests: CombineTestCase {
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testLocationNotAuthorized() throws {
        
        let locationManager = MockLocationManager(authorizationStatus: .denied)
        let locationProvider = LocationService(locationManager:locationManager)
        
        var providerState:LocationProviderState?
        var returnedError:Error?
        let expectation = self.expectation(description: "Location not authorised")
        
        locationProvider.$authorisationState.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error
            }
            expectation.fulfill()
        } receiveValue: { state in
            providerState = state
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)
        
        XCTAssertNil(returnedError, "Error should be nil")
        XCTAssertEqual(providerState, LocationProviderState.denied(status: .denied))
        
    }
    
    func testLocationAccessRestricted() throws {
        
        let locationManager = MockLocationManager(authorizationStatus: .restricted)
        let locationProvider = LocationService(locationManager:locationManager)
        
        var providerState:LocationProviderState?
        var returnedError:Error?
        let expectation = self.expectation(description: "Location access restricted")
        
        locationProvider.$authorisationState.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error
            }
            expectation.fulfill()
        } receiveValue: { state in
            providerState = state
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)
        
        XCTAssertNil(returnedError, "Error should be nil")
        XCTAssertEqual(providerState, LocationProviderState.denied(status: .restricted))
        
    }
    
    func testLocationAccessAlwaysAuthorized() throws {
        
        let locationManager = MockLocationManager(authorizationStatus: .authorizedAlways)
        let locationProvider = LocationService(locationManager:locationManager)
        
        var providerState:LocationProviderState?
        var returnedError:Error?
        let expectation = self.expectation(description: "Location access authorised always")
        
        locationProvider.$authorisationState.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error
            }
            expectation.fulfill()
        } receiveValue: { state in
            providerState = state
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)
        
        XCTAssertNil(returnedError, "Error should be nil")
        XCTAssertEqual(providerState, LocationProviderState.authorised(status: .authorizedAlways))
        
    }
    
    func testLocationAccessWhileUsing() throws {
        
        let locationManager = MockLocationManager(authorizationStatus: .authorizedWhenInUse)
        let locationProvider = LocationService(locationManager:locationManager)

        var providerState:LocationProviderState?
        var returnedError:Error?
        let expectation = self.expectation(description: "Location access authorised in use")
        
        locationProvider.$authorisationState.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error
            }
            expectation.fulfill()
        } receiveValue: { state in
            providerState = state
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)
        
        XCTAssertNil(returnedError, "Error should be nil")
        XCTAssertEqual(providerState, LocationProviderState.authorised(status: .authorizedWhenInUse))
    }
    
    func testDetermineLocationAccess() throws {
        
        let locationManager = MockLocationManager(authorizationStatus: .notDetermined)
        let locationProvider = LocationService(locationManager:locationManager)

        var providerState:LocationProviderState?
        var returnedError:Error?
        let expectation = self.expectation(description: "Location access authorised in use")
        
        locationProvider.$authorisationState.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error
            }
            expectation.fulfill()
        } receiveValue: { state in
            providerState = state
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)
        
        XCTAssertNil(returnedError, "Error should be nil")
        XCTAssertEqual(providerState, LocationProviderState.determiningAuthorisation)
    }
    
    func testAuthStatusFlow() throws {

        let locationManager = MockLocationManager(authorizationStatus: .notDetermined)
        let locationProvider = LocationService(locationManager:locationManager)

        var states = [LocationProviderState]()
        var returnedError:Error?
        let expectation = self.expectation(description: "Location access authorised in use")
        
        locationProvider.$authorisationState.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error
            }
            expectation.fulfill()
        } receiveValue: { state in
            states.append(state)
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)
        
        XCTAssertNil(returnedError, "Error should be nil")
        XCTAssertTrue(states.count == 2, "States array could contain exactly 2 elements")
        
        if states.count == 2 {
            XCTAssertTrue(states[0] == .authorised(status: .authorizedWhenInUse))
            XCTAssertTrue(states[1] == .locationUpdated(location: MockLocationManager.mockLocations.first!))
        }else{
            XCTFail("States array is incorrect")
        }
    }
    
    func testExistingAuthStatusFlow() throws {
        
        let locationManager = MockLocationManager(authorizationStatus: .authorizedWhenInUse)
        let locationProvider = LocationService(locationManager:locationManager)
        var states = [LocationProviderState]()
        var returnedError:Error?
        let expectation = self.expectation(description: "Location access authorised in use")
        
        locationProvider.$authorisationState.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                returnedError = error
            }
            expectation.fulfill()
        } receiveValue: { state in
            states.append(state)
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: waitTimeout)
        
        XCTAssertNil(returnedError, "Error should be nil")
        XCTAssertTrue(states.count == 2, "States array could contain exactly 2 elements")
        
        if states.count == 1 {
            XCTAssertTrue(states[0] == .locationUpdated(location: MockLocationManager.mockLocations.first!))
        }else{
            XCTFail("States array is incorrect")
        }
    
    }
        
    
    func testUpdateLocation() async throws {
                
//        let location = CLLocation(latitude: 50.3344340, longitude: -4.7712680)
//        
//        let locationManager = MockLocationManager(location: location)
//        let locationProvider = LocationService(locationManager:locationManager)
//        
//        locationProvider.$currentLocation.map {
//            XCTAssertTrue($0 == LocationProviderState.locationUpdated(location: location))
//        
//            switch $0 {
//            case .locationUpdated(let location):
//                XCTAssertTrue(location.coordinate.latitude == 50.3344340)
//                XCTAssertTrue(location.coordinate.latitude == -4.7712680)
//            case .denied(status: .notDetermined),
//                    .denied(status: .authorizedAlways),
//                    .denied(status: .authorizedWhenInUse),
//                    .denied(status: _),
//                    .authorised(status: .notDetermined),
//                    .authorised(status: .restricted),
//                    .authorised(status: .denied),
//                    .authorised(status: .authorizedWhenInUse),
//                    .authorised(status: _),
//                    .determiningAuthorisation,
//                    .determiningUserLocation,
//                    .error:
//                XCTFail("Should only return location")
//            }
//            
//        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
