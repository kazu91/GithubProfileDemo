//
//  GithubService.swift
//  GithubProfileDemo
//
//  Created by Kazu on 23/9/24.
//

import Foundation

protocol GithubServiceProtocol {
    func getProfile(name: String) async throws -> GithubProfileModel
    func getListRepositories(name: String, page: Int, size: Int) async throws -> [GithubRepoModel]
}

class GithubService<Client: APIClient>: GithubServiceProtocol where Client.EndpointType == GitHubEndpoint {
    
    var apiClient: Client
    
    init(apiClient: Client) {
        self.apiClient = apiClient
    }
    
    func getProfile(name: String) async throws -> GithubProfileModel {
        try await apiClient.request(.getProfile(name: Constant.GoogleName))
    }
    
    func getListRepositories(name: String, page: Int, size: Int) async throws -> [GithubRepoModel] {
        try await apiClient.request(.getListRepo(org:  Constant.GoogleName, pageNumber: page, pageSize: size))
    }
}
