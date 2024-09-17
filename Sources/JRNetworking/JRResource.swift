//
//  JRResource.swift
//
//
//  Created by Jonathan Rivera on 16/09/24.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public struct JRResource {
    public let resource: ResourceDefinition
    
    public init(resource: ResourceDefinition) {
        self.resource = resource
    }
}

public struct ResourceDefinition {
    public let route: String
    public let method: HTTPMethod
    
    public init(route: String, method: HTTPMethod) {
        self.route = route
        self.method = method
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
