//
//  JRResource.swift
//
//
//  Created by Jonathan Rivera on 16/09/24.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public struct JRResource {
    let resource: ResourceDefinition
}

public struct ResourceDefinition {
    let route: String
    let method: HTTPMethod
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
