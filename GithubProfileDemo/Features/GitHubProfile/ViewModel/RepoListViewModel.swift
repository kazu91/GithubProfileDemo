//
//  RepoListViewModel.swift
//  GithubProfileDemo
//
//  Created by Kazu on 23/9/24.
//

import Foundation

class RepoListViewModel: ObservableObject {
    @Published var repos: [GithubRepoModel] = []
    
    @Published var isLoading: Bool = false
    
    var page = 1
    
    let pageSize = 10
    
    var canLoadNextPage: Bool = false
    
    
    private let service: GithubServiceProtocol
    
    
    init(service: GithubServiceProtocol = GithubService(apiClient: URLSessionAPIClient<GitHubEndpoint>())) {
        self.service = service
    }
    
    @MainActor
    func fetchFreshListRepo() async throws{
        page = 1
        
        let models: [GithubRepoModel] = try await service.getListRepositories(name: Constant.GoogleName, page: page, size: pageSize)
        
        repos.removeAll()
        
        repos.append(contentsOf: models)
        
        canLoadNextPage = pageSize <= models.count
    }
    
    @MainActor
    func fetchNextListRepo() async {
        if !canLoadNextPage {
            return
        }
        
        do {
            isLoading = true
            defer { isLoading = false }
            
            page += 1
            
            let models: [GithubRepoModel] = try await service.getListRepositories(name: Constant.GoogleName, page: page, size: pageSize)
            
            repos.append(contentsOf: models)
            
            canLoadNextPage = pageSize <= models.count
            
        } catch {
            page -= 1
            switch error {
                
            default:
                print(error)
            }
        }
    }
}
