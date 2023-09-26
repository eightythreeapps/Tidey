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
    case serverError
    case unknownError
    case forbidden
    case notFound
    case tooManyRequests
}
