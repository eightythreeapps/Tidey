//
//  CombineTestCase.swift
//  TideyTests
//
//  Created by Ben Reed on 23/10/2023.
//

import XCTest
import Combine
@testable import Tidey

class CombineTestCase: XCTestCase {
    var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    let waitTimeout = 10.0
}
