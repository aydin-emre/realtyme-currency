//
//  NetworkError.swift
//  Interview
//
//  Created by Emre AYDIN on 16.04.2022.
//

import Foundation

enum NetworkError: Error {
    case statusCode
    case decoding
    case invalidImage
    case invalidURL
    case other(Error)

    static func map(_ error: Error) -> NetworkError {
        return (error as? NetworkError) ?? .other(error)
    }
}
