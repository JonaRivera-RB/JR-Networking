//
//  ClientConfiguration.swift
//
//
//  Created by Jonathan Rivera on 16/09/24.
//

import Foundation

public struct ClientConfiguration {
    let baseURL: String
    let httpHeaders: HTTPHeaders
    let sessionConfiguration: URLSessionConfiguration
    let logOutAction: ((Decodable?) -> ())?
    
    public init(baseURL: String,
                httpHeaders: HTTPHeaders,
                sessionConfiguration: URLSessionConfiguration = .default,
                logOutAction: ((Decodable?) -> ())? = nil) {
        self.baseURL = baseURL
        self.httpHeaders = httpHeaders
        self.sessionConfiguration = sessionConfiguration
        self.logOutAction = logOutAction
    }
}

