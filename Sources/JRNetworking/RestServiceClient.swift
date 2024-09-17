//
//  RestServiceClient.swift
//
//
//  Created by Jonathan Rivera on 16/09/24.
//

import Combine
import Foundation

public typealias JSON = [String: Any]

open class RestServiceClient {
    
    private let baseURL: String
    private let headers: HTTPHeaders
    private let sessionConfiguration: URLSessionConfiguration
    
    public init(configuration: ClientConfiguration) {
        baseURL = configuration.baseURL
        headers = configuration.httpHeaders
        sessionConfiguration = configuration.sessionConfiguration
    }
    
    public func request<T: Decodable, U: Decodable>(resource: JRResource,
                                                    parameters: JSON? = nil,
                                                    headers: HTTPHeaders? = nil,
                                                    type: T.Type,
                                                    errorType: U.Type) -> AnyPublisher<T, Error> {
        let fullURLString = baseURL + resource.jrResource.route
        
        guard let url = URL(string: fullURLString) else {
            return Fail(error: JRNetworkingError.invalidRequestError("Invalid URL: \(fullURLString)")).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = resource.jrResource.method.rawValue
        
        headers?.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if resource.jrResource.method != .get, let parameters = parameters {
            if let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
                urlRequest.httpBody = data
                debugPrint(url: fullURLString, jsonData: data, title: "Request JSON")
            }
        }
        
        return URLSession(configuration: sessionConfiguration).dataTaskPublisher(for: urlRequest)
            .mapError { error -> JRNetworkingError in
                if error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
                    return .noInternetConnection
                }
                return .unexpectedError(error)
            }
            .tryMap { [weak self] (data, response) -> (data: Data, response: URLResponse) in
                guard let urlResponse = response as? HTTPURLResponse else {
                    self?.debugPrint(url: fullURLString, jsonData: data, title: "Response JSON")
                    throw JRNetworkingError.invalidResponse
                }
                
                switch urlResponse.statusCode {
                case 401:
                    let decoder = JSONDecoder()
                    self?.debugPrint(url: fullURLString, jsonData: data, title: "Response JSON")
                    do {
                        let apiError = try decoder.decode(errorType, from: data)
                        throw JRNetworkingError.apiError(urlResponse.statusCode, error: apiError)
                    } catch {
                        throw JRNetworkingError.invalidResponse
                    }
                case 400, 402...599:
                    let decoder = JSONDecoder()
                    self?.debugPrint(url: fullURLString, jsonData: data, title: "Response JSON")
                    do {
                        let apiError = try decoder.decode(errorType, from: data)
                        throw JRNetworkingError.apiError(urlResponse.statusCode, error: apiError)
                    } catch {
                        throw JRNetworkingError.parsingError(error, "Failed parsing object: \(String(describing: T.self))")
                    }
                default:
                    break
                }
                
                return (data, response)
            }
            .map(\.data)
            .tryMap { data -> T in
                let decoder = JSONDecoder()
                self.debugPrint(url: fullURLString, jsonData: data, title: "Response JSON")
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw JRNetworkingError.parsingError(error, "Failed parsing object: \(String(describing: T.self))")
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func debugPrint(url: String, jsonData: Data, title: String) {
        #if DEBUG
        guard let json = String(data: jsonData, encoding: .utf8) else { return }
        print("⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃")
        print("‣ URL : \(url)")
        print("‣ \(title) : \(json)")
        NSLog("⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃")
        #endif
    }
}

