//
//  JRNetworkingError.swift
//  
//
//  Created by Jonathan Rivera on 16/09/24.
//

import Foundation

public enum JRNetworkingError: Error {
    case invalidRequestError(String)
    case invalidResponse
    case noInternetConnection
    case apiError(Int, error: Decodable)
    case unexpectedError(Error)
    case parsingError(Error, String)
}

