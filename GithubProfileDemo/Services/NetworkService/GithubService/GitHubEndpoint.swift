//
//  GitHubEndpoint.swift
//  GithubProfileDemo
//
//  Created by Kazu on 23/9/24.
//

import Foundation

enum GitHubEndpoint: APIEndpoint {
    case getProfile(name: String)
    case getListRepo(org: String, pageNumber: Int, pageSize: Int)
    
    var baseURL: URL {
        return URL(string: Constant.BaseUrl.urlString)!
    }
    
    var path: String {
        switch self {
        case .getProfile(let name):
            return "/\(name)"
        case .getListRepo(let orgName, _, _):
            return "/\(orgName)/repos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile, .getListRepo:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getProfile, .getListRepo:
            return [:]
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getProfile:
            return [:]
        case .getListRepo(_, let page, let size):
            return [
                "page":page,
                "per_page": size
            ]
        }
    }
}
