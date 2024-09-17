# JR Networking

**JR Networking** is a Swift library designed to simplify communication with web APIs in iOS and macOS applications. It leverages Combine to handle requests and responses reactively, providing a flexible and configurable approach to managing HTTP requests and error handling.

## Features

- **HTTP Request Handling**: Facilitates the configuration and sending of HTTP requests, including GET, POST, DELETE, and PATCH methods.
- **Error Handling**: Provides an enumeration for handling various types of network and API errors.
- **Flexible Configuration**: Allows configuration of the client with HTTP headers, session settings, and logout actions.
- **Debugging Support**: Includes support for debugging requests and responses in DEBUG mode.
- **JSON Support**: Handles JSON serialization and deserialization in a straightforward and configurable manner.

## Installation

To add this library to your Swift project, include it as a dependency in your `Package.swift` file:

```swift
// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "JRNetworking",
    platforms: [
        .iOS(.v14), // Adjust based on your minimum iOS version
        .macOS(.v11) // Adjust based on your minimum macOS version
    ],
    products: [
        .library(
            name: "JRNetworking",
            targets: ["JRNetworking"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "JRNetworking",
            dependencies: []),
        .testTarget(
            name: "JRNetworkingTests",
            dependencies: ["JRNetworking"]),
    ]
)
```

## Usage

To use JR Networking in your project, start by configuring the client:

```swift
import JRNetworking

let configuration = ClientConfiguration(
    baseURL: "https://api.example.com",
    httpHeaders: ["Authorization": "Bearer YOUR_TOKEN"],
    sessionConfiguration: .default
)

let restClient = RestClient(configuration: configuration)
```

To make a request:

```swift
import Combine
import JRNetworking

// Define a Decodable model for your API response
struct User: Decodable {
    let id: Int
    let name: String
}

// Define the resource for your API endpoint
struct UserResource: Resource {
    var resource: (method: HTTPMethod, route: String) {
        return (.get, "/users")
    }
}

// Create an instance of the resource
let usersResource = UserResource()

// Make the request
let cancellable = restClient.request(
    resource: usersResource,
    type: [User].self, // Expected response type
    errorType: NetworkingError.self // Error handling type
)
.sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        print("The request completed successfully.")
    case .failure(let error):
        print("The request failed with error: \(error)")
    }
}, receiveValue: { users in
    for user in users {
        print("User: \(user.name)")
    }
})

```

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

Made with love by Jonathan Rivera.

