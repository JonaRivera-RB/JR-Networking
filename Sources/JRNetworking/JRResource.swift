//
//  JRResource.swift
//
//
//  Created by Jonathan Rivera on 16/09/24.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public protocol JRResource {
    var jrResource: (method: HTTPMethod, route: String) { get }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
