//
//  APIClient.swift
//  GithubProfileDemo
//
//  Created by Kazu on 23/9/24.
//

import Foundation

//MARK: - APIClient
protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T
}

//MARK: - URLSessionProtocol
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }

//MARK: - API Error
enum APIError:  Error {
    case noInternetConnection
    case invalidResponse
    case clientError(message: String)
    case serverError
}

//MARK: - URLSessionAPIClient
class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    
    private let urlSession: URLSessionProtocol
    private let urlCache: URLCache
    
    init(urlCache: URLCache = .shared, urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlCache = urlCache
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T  {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if endpoint.method == .get && !(endpoint.parameters.isEmpty) {
            components?.queryItems = endpoint.parameters.map({ param in
                URLQueryItem(name: param.key, value: "\(param.value)")
            })
        }
        
        guard let newUrl = components?.url else {
            throw APIError.clientError(message: "Invalid URL")
        }
        
        var request = URLRequest(url: newUrl)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        if endpoint.method == .post || endpoint.method == .put {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: endpoint.parameters)
            } catch {
                throw APIError.clientError(message: "Invalid Body Parameters")
            }
        }
        
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.serverError
        }
        
        switch response.statusCode {
        case 400 ..< 500:
            if response.statusCode == 404 {
                throw APIError.clientError(message: "Invalid URL")
            }
            throw APIError.clientError(message: response.debugDescription)
        case 500 ..< 600:
            throw APIError.serverError
        default: break
        }
        
        let cachedResponse = CachedURLResponse(response: response, data: data)
        
        urlCache.storeCachedResponse(cachedResponse, for: request)
        
        let jsonDecoder = JSONDecoder()

        let decodedData = try jsonDecoder.decode(T.self, from: data)
        
        return decodedData
    }
}
