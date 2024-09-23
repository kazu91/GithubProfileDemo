//
//  MockResponseModel.swift
//  GithubProfileDemoTests
//
//  Created by Kazu on 24/9/24.
//

import Foundation

struct MockResponseModel: Decodable {
    let name: String
}

struct MockEndpoint: APIEndpoint {
    var baseURL: URL { URL(string: "https://example.com")! }
    var path: String { "/test" }
    var method: HTTPMethod { .get }
    var headers: [String : String]? { nil }
    var parameters: [String : Any] { [:] }
    
    static let example = MockEndpoint()
}

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?
    var response: URLResponse?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (data ?? Data(), response ?? HTTPURLResponse())
    }
}
