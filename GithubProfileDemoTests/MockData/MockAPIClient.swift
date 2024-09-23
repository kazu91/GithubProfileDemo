//
//  MockAPIClient.swift
//  GithubProfileDemoTests
//
//  Created by Kazu on 24/9/24.
//

import Foundation

class MockProfileAPIClient: APIClient {
    typealias EndpointType = GitHubEndpoint
    
    var result: Result<GithubProfileModel, APIError>?
    
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T {
        switch result {
        case .success(let data as T):
            return data
        case .failure(let error):
            throw error
        default:
            fatalError("MockAPIClient result is not set or invalid type")
        }
    }
}

class MockRepoListAPIClient: APIClient {
    typealias EndpointType = GitHubEndpoint
    
    var result: Result<[GithubRepoModel], APIError>?
    
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T {
        switch result {
        case .success(let data as T):
            return data
        case .failure(let error):
            throw error
        default:
            fatalError("MockAPIClient result is not set or invalid type")
        }
    }
}

