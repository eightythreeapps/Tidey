//
//  TideyDataProviderTests.swift
//  TideyTests
//
//  Created by Ben Reed on 22/09/2023.
//

import XCTest
@testable import Tidey

final class TideyDataProviderTests: XCTestCase {
    
    var dataProvider:TideDataProvider!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.dataProvider = MockDataProvider.TestProvider.TideDataProviderEmpty
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
