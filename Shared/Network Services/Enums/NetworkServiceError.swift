//
//  NetworkServiceError.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 11/04/2023.
//

import Foundation

enum NetworkServiceError: Error {
    case badUrl
    case parsingError
    case noResponse
    case unauthorised
    case httpError(code:Int)
    case unknownError(error:Error)
}
